from pathlib import Path

import pandas as pd


# Step 1: Tell Python where the project folders are.
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_FILE = PROJECT_ROOT / "data" / "raw" / "SuperStoreOrders.csv"
OUTPUT_FILE = PROJECT_ROOT / "data" / "processed" / "superstore_clean_learning.csv"


# Step 2: Load the raw CSV into a pandas DataFrame.
# A DataFrame is like an Excel table inside Python.
df = pd.read_csv(RAW_FILE, encoding="latin1")

print("STEP 2: Raw data loaded")
print("Rows and columns:", df.shape)
print(df.head())
print()


# Step 3: Check the column names.
print("STEP 3: Original columns")
print(df.columns.tolist())
print()


# Step 4: Clean column names.
# Example: "Order Date" becomes "order_date".
df.columns = (
    df.columns
    .str.replace("ï»¿", "", regex=False)
    .str.replace("\ufeff", "", regex=False)
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

print("STEP 4: Cleaned columns")
print(df.columns.tolist())
print()


# Step 5: Check data types before cleaning.
# object usually means text/string.
print("STEP 5: Data types before date conversion")
print(df[["order_date", "ship_date", "sales", "profit"]].dtypes)
print()


# Step 6: Convert date columns.
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
df["ship_date"] = pd.to_datetime(df["ship_date"], errors="coerce")

print("STEP 6: Data types after date conversion")
print(df[["order_date", "ship_date"]].dtypes)
print()


# Step 7: Convert numeric columns.
# Some CSV columns look like numbers but are stored as text.
numeric_columns = ["sales", "quantity", "discount", "profit", "shipping_cost"]

for column in numeric_columns:
    df[column] = (
        df[column]
        .astype(str)
        .str.replace("$", "", regex=False)
        .str.replace(",", "", regex=False)
    )
    df[column] = pd.to_numeric(df[column], errors="coerce")

print("STEP 7: Data types after numeric conversion")
print(df[numeric_columns].dtypes)
print()


# Step 8: Create useful time columns for Power BI.
df["order_year"] = df["order_date"].dt.year
df["order_month"] = df["order_date"].dt.month
df["order_month_name"] = df["order_date"].dt.month_name()
df["order_quarter"] = "Q" + df["order_date"].dt.quarter.astype(str)

print("STEP 8: New time columns")
print(df[["order_date", "order_year", "order_month", "order_month_name", "order_quarter"]].head())
print()


# Step 9: Create business metrics.
df["profit_margin"] = df["profit"] / df["sales"]
df["sales_per_unit"] = df["sales"] / df["quantity"]
df["shipping_days"] = (df["ship_date"] - df["order_date"]).dt.days

print("STEP 9: New business columns")
print(df[["sales", "quantity", "profit", "profit_margin", "sales_per_unit", "shipping_days"]].head())
print()


# Step 10: Remove duplicate rows.
rows_before = len(df)
df = df.drop_duplicates()
rows_after = len(df)

print("STEP 10: Duplicate check")
print("Rows before:", rows_before)
print("Rows after:", rows_after)
print("Duplicates removed:", rows_before - rows_after)
print()


# Step 11: Save the cleaned file.
OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(OUTPUT_FILE, index=False)

print("STEP 11: Cleaned CSV saved")
print(OUTPUT_FILE)
