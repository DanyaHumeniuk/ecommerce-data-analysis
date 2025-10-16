-- Stores SQL queries to calculate KPIs for reporting

-- KPI 1: Total Sales Revenue (for the entire period)
SELECT SUM(Sales_Revenue) AS Total_Sales_Revenue
FROM FACT_Sales;

-- KPI2: Average Order Value (AOV)
SELECT SUM(Sales_Revenue) / COUNT(DISTINCT InvoiceNo) AS Average_Order_Value
FROM FACT_Sales;

-- KPI3: Sales Volume (Revenue) by Country/Region
SELECT
    T2.Country,
    SUM(T1.Sales_Revenue) AS Revenue_by_Country,
    COUNT(Distinct T1.InvoiceNo) AS Total_Orders
FROM FACT_Sales AS T1
JOIN DIM_Customer AS T2 ON T1.CustomerID = T2.CustomerID
GROUP BY T2.Country
ORDER BY Revenue_by_Country DESC;

-- KPI 4: Top 10 Selling Products (Revenue Rank)
SELECT 
    T2.Description,
    SUM(T1.Sales_Revenue) AS Total_Product_Revenue,
    SUM(T1.Quantity) AS TOTAL_Units_Sold
FROM FACT_Sales AS T1
JOIN DIM_Product AS T2 ON T1.StockCode = T2.StockCode
GROUP BY T2.Description
ORDER BY Total_Product_Revenue DESC
LIMIT 10;