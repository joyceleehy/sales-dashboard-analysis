-- ============================================
-- Sales Dashboard Analysis
-- SQL Validation Queries
-- Dataset: Kaggle SuperStore Sales
-- Tool: SQLite (DB Browser)
-- Author: Joyce Lee
-- ============================================


-- ============================================
-- QUERY 1: KPI Validation
-- Validates: Executive Overview KPI Cards
-- ============================================

SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM superstore_clean;

-- Expected Results:
-- total_sales       = 12,642,905
-- total_profit      = 1,469,034.82
-- profit_margin_pct = 11.62%
-- total_orders      = 25,035
-- total_quantity    = 178,312
-- avg_discount_pct  = 14.29%
-- avg_shipping_cost = 26.38


-- ============================================
-- QUERY 2: Monthly Sales Trend
-- Validates: Sales Trend Analysis Page
-- ============================================

SELECT 
    order_year,
    order_month,
    order_month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_clean
GROUP BY order_year, order_month, order_month_name
ORDER BY order_year, order_month;

-- Key Insight:
-- September 2013 had lowest profit month ($773)
-- despite $99K in sales


-- ============================================
-- QUERY 3: Category Profitability
-- Validates: Product Performance Page
-- ============================================

SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY category
ORDER BY total_sales DESC;

-- Expected Results:
-- Technology     = $4,744,691 | 13.99% margin
-- Furniture      = $4,110,884 | 6.98% margin (lowest)
-- Office Supplies= $3,787,330 | 13.69% margin


-- ============================================
-- QUERY 4: Region & Market Performance
-- Validates: Regional Market Analysis Page
-- ============================================

SELECT 
    region,
    market,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY region, market
ORDER BY total_sales DESC;

-- Key Insights:
-- Canada has highest profit margin (26.62%)
-- Southeast Asia has lowest profit margin (2.02%)
-- North Asia has highest avg shipping cost ($40.65)


-- ============================================
-- QUERY 5: Discount Impact on Profit
-- Validates: Discount Impact Scatter Chart
-- ============================================

SELECT 
    sub_category,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY sub_category
ORDER BY avg_discount_pct DESC;

-- Key Insights:
-- Tables: 29.07% discount = -$64,083 profit (only loss-making sub-category)
-- Paper: 10.95% discount = 24.23% margin (lowest discount, highest margin)
-- Copiers: 11.71% discount = $258,567 profit (strong product, no need to discount)


-- ============================================
-- QUERY 6: Top 10 Customers by Sales
-- Validates: Customer Segment Analysis Page
-- ============================================

SELECT 
    customer_name,
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_clean
GROUP BY customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;

-- Key Insights:
-- Sean Miller: Top 5 by sales but negative profit (-1.16%)
-- Hunter Lopez: Lowest sales in Top 10 but highest margin (25.84%)
-- Tamara Chand: Best balance - high sales ($37K) and strong margin (23.16%)


-- ============================================
-- QUERY 7: Sales Growth by Year
-- Validates: Sales Growth % Chart
-- ============================================

SELECT 
    order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore_clean
GROUP BY order_year
ORDER BY order_year;

-- Expected Results:
-- 2011: $0.9M
-- 2012: $1.0M (+12%)
-- 2013: $1.3M (+33%)
-- 2014: $1.6M (+21%)


-- ============================================
-- QUERY 8: Products with Negative Profit
-- Validates: Negative Profit Table
-- ============================================

SELECT 
    product_name,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM superstore_clean
GROUP BY product_name, category
HAVING total_profit < 0
ORDER BY total_profit ASC
LIMIT 15;

-- Shows products losing money despite generating sales
-- Most losses concentrated in Furniture and Office Supplies
