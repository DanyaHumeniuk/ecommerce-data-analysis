# Data Modelling and KPI Calculation (SQL)

import sqlite3          # lets you work with SQLite databases (lightweight databases)
import pandas as pd

DB_NAME = 'ecommerce_analysis.db'
CLEANED_FILE = 'cleaned_ecommerce_data.csv'

try:
    df = pd.read_csv(CLEANED_FILE)
except FileNotFoundError:
    print(f"Error: File {CLEANED_FILE} not found. Run 'clean_and_load.py' first.")
    exit()

conn = sqlite3.connect(DB_NAME)                  # creates or opens the SQLite database file
cursor = conn.cursor()                           # lets you run SQL commands

print("Creating DIM_Product and DIM_Customer tables...")

df_product = df[['StockCode', 'Description']].drop_duplicates()
df_product.to_sql('DIM_Product', conn, if_exists='replace', index=False)       # saves df_product into SQLite database(conn) as DIM_Product

df_customer = df[['CustomerID', 'Country']].drop_duplicates()
df_customer['Customer_Segment'] = 'Unclassified'
df_customer.to_sql('DIM_Customer', conn, if_exists='replace', index=False)

print("Creating FACT_Sales table...")

df_fact = df[['InvoiceNo', 'StockCode', 'CustomerID', 'InvoiceDate', 'Quantity', 'UnitPrice', 'Sales_Revenue']]
df_fact.to_sql('FACT_Sales', conn, if_exists='replace', index=True, index_label='SalesID')

conn.commit()
conn.close()
print(f"Database '{DB_NAME}' created and data loaded. SQL Data Modelling complete.")