# E-Commerce Sales Performance and Customer Analysis 📈

[**Click here to view the final interactive Tableau Dashboard!**](https://public.tableau.com/app/profile/danylo.humeniuk/viz/ECommerceSalesPerformanceAnalysis-CustomerRFM/E-CommerceSalesPerformanceCustomerAnalysis?publish=yes)

***

## 🌟 Project Overview

This project implements a comprehensive **end-to-end data analysis pipeline** focused on historical e-commerce transactional data. The goal was to transform raw sales records into actionable intelligence by creating a structured data warehouse, performing advanced **data mining (clustering)**, and delivering key business insights through a professional reporting dashboard.

The project demonstrates proficiency across the core tools used in modern data analysis: **Python** for ETL, **SQL** for data modeling, **R** for statistical analysis, and **Tableau** for visualization.

### Key Deliverables & Insights

* **Structured Data Model:** Implementation of a Star Schema (FACT/DIM tables) for efficient KPI querying.
* **Customer Pattern Identification:** Use of **R (k-means clustering)** on RFM metrics to segment customers into High-Value, Mid-Value, and Low-Value groups.
* **Trend Analysis:** Statistical confirmation that **Order Frequency** is the most significant driver of customer spend (**Monetary** value).
* **KPI Reporting:** An interactive Tableau dashboard presenting **Total Revenue**, **Average Order Value (AOV)**, and customer segment distribution.

***

## 🛠️ Technology Stack

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Data Ingestion/ETL** | Python, Pandas | Data cleaning, Quality Assurance (QA), and simulation of an external **API call** (currency exchange). |
| **Data Modeling** | SQL (SQLite) | Design and implementation of a Star Schema, and calculation of core business **KPIs**. |
| **Advanced Analysis**| R, RSQLite, Cluster | **Data Mining** (k-means clustering) for pattern discovery and **Statistical Modeling** for trend identification. |
| **Reporting/BI** | Tableau Public, Looker (Conceptual) | Interactive data visualization and creation of a conceptual **LookML model** for enterprise BI. |

***

## ⚙️ Data Pipeline Architecture

The project utilized a phased approach to transform raw data into a final report:

1.  **Phase 1: Ingestion & QA (Python/Pandas):** Raw data was loaded, cleaned (handling nulls, negatives, and invalid records), and enriched (calculating `Sales_Revenue`).
2.  **Phase 2: Modeling & Loading (Python/SQL):** Cleaned data was loaded into an SQLite database, establishing `FACT_Sales`, `DIM_Customer`, and `DIM_Product` tables.
3.  **Phase 3: Enrichment & Analysis (R):** The `analysis.R` script calculated customer RFM scores, performed **k-means clustering**, and updated the `DIM_Customer` table with the new `Customer_Segment` column.
4.  **Phase 4: Visualization (Tableau):** The final enriched database was connected to Tableau Public to generate the interactive report.

***

## 🚀 Getting Started

To run the full pipeline locally, ensure you have **Python 3.x** and **R** installed, along with the necessary packages (pandas, sqlite3 in Python; RSQLite, dplyr, cluster in R).

### Execution Steps

1.  **Clone the Repository:**
    ```bash
    git clone [Your Repository URL]
    cd ECommerceDataAnalysis
    ```
2.  **Run Python ETL:** Execute the scripts in sequence to build the database.
    ```bash
    python api_fetch.py
    python clean_and_load.py
    python db_setup_load.py 
    ```
3.  **Run R Analysis:** Execute the `analysis.R` script in your R console/RStudio to perform clustering and update the database.
    ```r
    # In R/RStudio console:
    source("analysis.R")
    ```
4.  **Visualize:** Connect Tableau Public (or Power BI Desktop) to the generated `ecommerce_analysis.db` file (or use the exported CSV files) to explore the data.

***

## 📂 Project Files & Code Samples

| File/Output | Description |
| :--- | :--- |
| `api_fetch.py` | Handles initial data ingestion and currency API simulation. |
| `clean_and_load.py` | Dedicated script for Python-based data cleaning and validation. |
| `db_setup_load.py` | Creates the relational structure (`FACT` and `DIM` tables) in SQLite. |
| `analysis.R` | Core statistical script for **RFM calculation** and **k-means clustering**. |
| `kpi_queries.sql` | Contains sample SQL for retrieving KPIs like AOV and Total Revenue. |
| `looker_conceptual_model.md` | Conceptual LookML model demonstrating enterprise BI reporting structure. |