library(RSQLite)
library(dplyr)       # Package for data manipulation

DB_NAME <- "ecommerce_analysis.db"

conn <- dbConnect(RSQLite::SQLite(), DB_NAME)

# 1. Data Mining: Retrieve Customer Data for Pattern Identification (RFM Analysis - Recency, Frequency, Monetary)
# Calculate Recency (days since last purchase), Frequency (total orders) and Monetary (total spent)
customer_data <- dbGetQuery(conn, "
    WITH Last_Order AS (
        SELECT
            CustomerID,
            MAX(InvoiceDate) AS MaxInvoiceDate
        FROM FACT_Sales
        GROUP BY CustomerID
    ),
    RFM_Base AS (
        SELECT
            s.CustomerID,
            JULIANDAY('2011-12-10') - JULIANDAY(t1.MaxInvoiceDate) AS Recency,
            COUNT(DISTINCT s.InvoiceNo) AS Frequency,
            SUM(s.Sales_Revenue) AS Monetary
        FROM FACT_Sales s
        INNER JOIN Last_Order t1 ON s.CustomerID = t1.CustomerID
        GROUP BY s.CustomerID
    )
    SELECT * FROM RFM_BASE
") 

# 2. Data Cleaning for Clustering
# We capture the CustomerID list BEFORE scaling, filtering out any NA values.
rfm_filtered <- customer_data %>%
  # Select the variables we care about
  select(CustomerID, Recency, Frequency, Monetary) %>%
  # Remove customers who may have NA values in the RFM calculation
  na.omit() 

# Separate the customer IDs from the variables to be scaled
customer_ids_for_clustering <- rfm_filtered$CustomerID

# Scale the variables
rfm_scaled <- rfm_filtered %>%
  select(Recency, Frequency, Monetary) %>%
  scale()

# 3. K-means Clustering (Data Mining - Pattern Identification)
# Choosing 3 segments (k=3) for High, Mid, and Low Value
# Note: customer_ids_for_clustering is guaranteed to have the same row count as rfm_scaled
set.seed(42) # for reproducible results
k <- 3
customer_clusters <- kmeans(rfm_scaled, centers = k, nstart = 25)

# 4. Pattern Interpretation and Mapping
# Map the cluster results back using the correctly filtered IDs
clustered_customers <- data.frame(
  CustomerID = customer_ids_for_clustering, # NOW using the correctly filtered list of IDs
  Cluster = customer_clusters$cluster
)
# (Keep the rest of Section 4 and all of Sections 5 and 6 as they are)

# Assign meaningful segment names based on the 'Monetary' centroid value
segment_names <- c("High-Value", "Mid-Value", "Low-Value")

segment_map <- data.frame(
  Cluster = 1:k,
  Monetary_Center = customer_clusters$centers[, "Monetary"]
) %>%
  arrange(desc(Monetary_Center)) %>%
  mutate(Segment = segment_names)

clustered_customers <- data.frame(
    CustomerID = customer_data$CustomerID[as.numeric(rownames(rfm_scaled))],
    Cluster = customer_clusters$cluster
) %>%
    left_join(segment_map, by = "Cluster") %>%
    select(CustomerID, Customer_Segment = Segment)

print("Identified Customer Patterns (Segments):")
print(table(clustered_customers$Customer_Segment))

# 5. Trend Identification (Statistical Modeling)
# Simple regression to show which RFM variables are significant predictors of Monetary Value
model <- lm(Monetary ~ Frequency + Recency, data = customer_data)
print("\nTrend Analysis (Recency, Frequency impact on Monetary Value):")
print(summary(model))

# 6. Update SQL Table with New Pattern
print("\nUpdating DIM_Customer table in SQL database...")

dbWriteTable(conn, "TEMP_Segments", clustered_customers, overwrite = TRUE)

dbExecute(conn, "
    UPDATE DIM_Customer
    SET Customer_Segment = (
        SELECT Customer_Segment
        FROM TEMP_Segments
        WHERE TEMP_Segments.CustomerID = DIM_Customer.CustomerID
    )
")
dbExecute(conn, "DROP TABLE TEMP_Segments")

dbDisconnect(conn)
print("R Analysis Complete. Customer Segments updated in SQL for reporting.")




