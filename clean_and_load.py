# Takes the output from api_fetch.py, cleans it, performs QA and prepares for SQL

import pandas as pd
import numpy as np

INPUT_FILE = 'raw_ecommerce_data.csv'
OUTPUT_FILE = 'cleaned_ecommerce_data.csv'

try:
    df = pd.read_csv(INPUT_FILE, encoding='unicode_escape', on_bad_lines='skip')        # enconding='unicode_escape' allows to read special characters

    df.dropna(subset=['InvoiceNo', 'CustomerID', 'Quantity', 'UnitPrice'], inplace=True) # inplace=True applies this directly to df, not to a copy

    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'], errors='coerce')               # errors='coerce' turns invalid dates to 'Not a Time'
    df['CustomerID'] = df['CustomerID'].astype(int)

    df = df[(df['Quantity'] > 0) & (df['UnitPrice'] > 0)]

    df['Sales_Revenue'] = df['Quantity'] * df['UnitPrice']                               # Primary KPI metric

    df_final = df[['InvoiceNo', 'StockCode', 'CustomerID', 'InvoiceDate', 'Quantity', 'UnitPrice', 'Sales_Revenue', 'Description', 'Country']]

    print(f"\nCleaned and QA Complete. Final row count: {len(df_final)}")

    df_final.to_csv(OUTPUT_FILE, index=False)
    print(f"Cleaned data saved as '{OUTPUT_FILE}'.")

except FileNotFoundError:
    print(f"Error: The file '{INPUT_FILE}' was not found. Please run 'api_fetch.py' first.")
except Exception as e:
    print(f"An error occured during cleaning: {e}")

