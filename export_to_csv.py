import sqlite3
import pandas as pd

DB_NAME = 'ecommerce_analysis.db'

try:
    conn = sqlite3.connect(DB_NAME)
    
    # Export FACT_Sales table (includes Revenue, Quantity, etc.)
    df_fact = pd.read_sql_query("SELECT * FROM FACT_Sales", conn)
    df_fact.to_csv('final_fact_sales.csv', index=False)
    print("Exported final_fact_sales.csv")

    # Export DIM_Customer table (CRITICAL: includes the R-derived Customer_Segment)
    df_dim_customer = pd.read_sql_query("SELECT * FROM DIM_Customer", conn)
    df_dim_customer.to_csv('final_dim_customer.csv', index=False)
    print("Exported final_dim_customer.csv")

    # Export DIM_Product table
    df_dim_product = pd.read_sql_query("SELECT * FROM DIM_Product", conn)
    df_dim_product.to_csv('final_dim_product.csv', index=False)
    print("Exported final_dim_product.csv")

    conn.close()

except sqlite3.OperationalError as e:
    print(f"ERROR: Could not connect to database. Ensure {DB_NAME} exists and is closed: {e}")
except Exception as e:
    print(f"An unexpected error occurred during export: {e}")