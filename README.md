# Sales Dashboard Analysis
### Retail Sales Performance Analysis using Python, SQL, and Power BI

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)

---

## Project Overview

This end-to-end data analytics portfolio project analyzes retail sales performance using the Kaggle SuperStore Sales dataset. The project covers the full analytics workflow — from raw data ingestion and Python-based cleaning, through SQL validation, to a 5-page interactive Power BI dashboard.

**Project Goal:** Analyze retail sales performance to uncover insights across sales trends, profit drivers, discount impact, product performance, regional performance, and customer segments.

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (pandas) | Data cleaning and preparation |
| SQLite | Data validation and SQL analysis |
| Power BI | Interactive dashboard and visualizations |
| DB Browser for SQLite | SQL query execution |
| VS Code | Python scripting environment |

---

## Dataset

- **Source:** [Kaggle SuperStore Sales Dataset](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting)
- **Records:** ~10,000 rows
- **Period:** 2011 – 2014
- **Fields:** Order details, customer info, product categories, sales, profit, discount, shipping

---

## Project Structure

```
sales-dashboard-analysis/
│
├── data/
│   ├── raw/
│   │   └── SuperStoreOrders.csv
│   └── processed/
│       ├── superstore_clean.csv
│       ├── fact_sales.csv
│       ├── dim_product.csv
│       └── dim_geo.csv
│
├── python/
│   └── data_cleaning.py
│
├── sql/
│   └── validation_queries.sql
│
├── dashboard/
│   └── SalesDashboard.pbix
│
└── README.md
```

---

## Part 1: Python Data Cleaning

The raw CSV was cleaned and prepared using Python and pandas. Key steps included:

- Loaded raw CSV and standardized column names
- Converted `order_date` and `ship_date` to date format
- Converted numeric columns: `sales`, `quantity`, `discount`, `profit`, `shipping_cost`
- Created derived columns: `order_year`, `order_month`, `order_month_name`, `order_quarter`
- Calculated `profit_margin` and `shipping_days`
- Removed duplicate rows
- Exported cleaned CSV files for Power BI consumption

> **Note:** Python cleaning script was developed with AI coding assistant (Codex) support. I reviewed, ran, and validated all steps and outputs independently.

---

## Part 2: Power BI Dashboard

A 5-page interactive dashboard built from `superstore_clean.csv`.

### Page 1: Executive Overview
High-level KPI summary with trend and category breakdown.

| KPI | Value |
|---|---|
| Total Sales | $12.6M |
| Total Profit | $1.47M |
| Profit Margin | 11.6% |
| Total Orders | 25K |
| Total Quantity | 178K |
| Avg Discount | 14.3% |
| Avg Shipping Cost | $26.38 |

**Visuals:** KPI Cards, Sales & Profit Trend (2011–2014), Sales by Category, Profit by Region

---

### Page 2: Sales Trend Analysis
Deep dive into year-over-year and seasonal patterns.

**Key Insights:**
- Sales grew consistently from $0.9M (2011) to $1.6M (2014)
- Sales growth rate: 12% (2012), 33% (2013), 21% (2014)
- Seasonal dip every June–July, strong recovery in Q4
- September 2013 had the lowest profit month ($773) despite $99K in sales

**Visuals:** Sales by Year, Monthly Seasonality, Sales by Quarter, YoY Sales vs Profit, Sales Growth %

---

### Page 3: Product Performance
Product and category-level profitability analysis.

**Key Insights:**
- Technology leads in sales ($4.7M) and profit margin (13.99%)
- Furniture has the lowest profit margin (6.98%) despite being 2nd in sales
- Tables is the only sub-category with negative profit (-$64K) — driven by 29% average discount
- Hoover Stove White has the largest individual product loss (-$5,700)

**Visuals:** Top 10 Products by Sales (gradient), Treemap by Category/Sub-Category, Profit by Sub-Category (diverging colours), Discount Impact Scatter, Negative Profit Table

---

### Page 4: Regional / Market Analysis
Geographic performance across regions and markets.

**Key Insights:**
- Central region leads in sales ($1.7M) but is part of EU market
- APAC is the most profitable market ($28.7K profit)
- Canada has the highest profit margin (26.62%) despite being the smallest market
- Southeast Asia has very low profit margin (2.02%) — high sales but barely profitable
- North Asia has the highest average shipping cost ($40.65)

**Visuals:** Sales by Region, Profit by Market, Sales by Country (Top 10), Shipping Cost by Region

---

### Page 5: Customer Segment Analysis
Segment-level and customer-level breakdown.

**Key Insights:**
- Consumer segment dominates with 56.43% of total sales
- All 3 segments have similar profit margins (~11.5–12%)
- Sean Miller is Top 5 customer by sales but generates negative profit (-1.16%)
- Hunter Lopez has the highest profit margin among top customers (25.84%)
- Tamara Chand offers the best balance — high sales ($37K) and strong margin (23.16%)

**Visuals:** Sales by Segment (Donut), Profit by Segment, Orders by Segment, Avg Discount by Segment, Sales vs Profit by Segment, Top 10 Customers Table, Profit Margin % Cards

---

## Part 3: SQL Validation

All dashboard metrics were validated using SQLite queries against `superstore_clean.csv`.

### Query 1: KPI Validation
```sql
SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM superstore_clean;
```

### Query 2: Monthly Sales Trend
```sql
SELECT 
    order_year, order_month, order_month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_clean
GROUP BY order_year, order_month, order_month_name
ORDER BY order_year, order_month;
```

### Query 3: Category Profitability
```sql
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY category
ORDER BY total_sales DESC;
```

### Query 4: Region Performance
```sql
SELECT 
    region, market,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM superstore_clean
GROUP BY region, market
ORDER BY total_sales DESC;
```

### Query 5: Discount Impact
```sql
SELECT 
    sub_category,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY sub_category
ORDER BY avg_discount_pct DESC;
```

### Query 6: Top 10 Customers
```sql
SELECT 
    customer_name, segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;
```

✅ All SQL results validated and matched Power BI dashboard figures.

---

## Key Business Insights

1. **Discount is destroying profit** — Tables sub-category has 29% avg discount and is the only loss-making sub-category (-$64K profit)
2. **Technology is the star** — highest sales ($4.7M) and strong margin (13.99%)
3. **Furniture underperforms** — 2nd highest sales but lowest margin (6.98%)
4. **Southeast Asia needs attention** — high sales volume but only 2.02% profit margin
5. **Canada is a hidden gem** — smallest market but highest profit margin (26.62%)
6. **Sales growing strongly** — 33% growth in 2013, consistent upward trend across all years
7. **Sean Miller risk** — top 5 customer by sales but generating negative profit

---

## Author

**Joyce Lee**
Data & BI Analyst | PL-300 Certified | People & HR Analytics
[LinkedIn](https://www.linkedin.com/in/joyceleehy) | [GitHub](https://github.com/joyceleehy)
