CREATE DATABASE retail_analytics;
USE retail_analytics;
CREATE TABLE fact_sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    segment VARCHAR(50),
    market VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_id VARCHAR(50),
    product_name VARCHAR(200),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    order_priority VARCHAR(50),
    year INT
);
SHOW TABLES;
SELECT COUNT(*) FROM fact_sales;
TRUNCATE TABLE fact_sales;
SHOW TABLES;
SHOW DATABASES;
USE retail_analytics;
SHOW TABLES;
SET GLOBAL local_infile = 1;
SHOW TABLES;
TRUNCATE TABLE fact_sales;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sales_clean.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, product_id, order_date, ship_date, sales, quantity)
SET
order_date = STR_TO_DATE(order_date, '%d-%m-%Y'),
ship_date  = STR_TO_DATE(ship_date, '%d-%m-%Y');
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:\Users\hp\Desktop\sales_clean.csv' 
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(order_id, product_id, order_date, ship_date, sales, quantity)
SET 
order_date = STR_TO_DATE(order_date, '%d-%m-%Y'),
ship_date  = STR_TO_DATE(ship_date, '%d-%m-%Y');
ALTER TABLE fact_sales
MODIFY order_date VARCHAR(20),
MODIFY ship_date VARCHAR(20);
TRUNCATE TABLE fact_sales;
SELECT COUNT(*) FROM fact_sales;
CREATE TABLE fact_sales_raw (
order_id VARCHAR(50),
customer_id VARCHAR(50),
product_id VARCHAR(50),
order_date VARCHAR(20),
ship_date VARCHAR(20),
sales VARCHAR(50),
quantity VARCHAR(20)
);
SELECT COUNT(*) FROM fact_sales;
USE retail_analytics;
CREATE TABLE fact_sales_raw (
order_id VARCHAR(50),
customer_id VARCHAR(50),
product_id VARCHAR(50),
order_date VARCHAR(20),
ship_date VARCHAR(20),
sales VARCHAR(50),
quantity VARCHAR(20)
);
TRUNCATE TABLE fact_sales_raw;
DESCRIBE fact_sales_raw;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.0/Uploads/sales_clean2.csv'
INTO TABLE fact_sales_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
@order_id,
@order_date,
@ship_date,
@ship_mode,
@customer_name,
@segment,
@state,
@country,
@market,
@region,
@product_id,
@category,
@sub_category,
@product_name,
@sales,
@quantity,
@discount,
@profit,
@shipping_cost,
@order_priority,
@year
)
SET
order_id   = @order_id,
product_id = @product_id,
order_date = @order_date,
ship_date  = @ship_date,
sales      = @sales,
quantity   = @quantity;
SELECT COUNT(*) FROM fact_sales;
USE retail_analytics;
DESCRIBE fact_sales;
SELECT COUNT(*)  FROM fact_sales_raw;
DESCRIBE fact_sales_raw;
SELECT *
FROM fact_sales_raw
LIMIT 5;
USE TABLE fact_sales (
order_id VARCHAR(50),
order_date VARCHAR(20),
ship_date VARCHAR(20),
ship_mode VARCHAR(50),
customer_name VARCHAR(100),
segment VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50),
market VARCHAR(50),
region VARCHAR(50),
product_id VARCHAR(50),
category VARCHAR(50),
sub_category VARCHAR(50),
product_name VARCHAR(200),
sales DECIMAL(12,2),
quantity INT,
discount DECIMAL(6,2),
profit DECIMAL(12,2),
shipping_cost DECIMAL(10,2),
order_priority VARCHAR(20),
year INT
);
DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
order_id VARCHAR(50),
order_date VARCHAR(20),
ship_date VARCHAR(20),
ship_mode VARCHAR(50),
customer_name VARCHAR(100),
segment VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50),
market VARCHAR(50),
region VARCHAR(50),
product_id VARCHAR(50),
category VARCHAR(50),
sub_category VARCHAR(50),
product_name VARCHAR(200),
sales DECIMAL(12,2),
quantity INT,
discount DECIMAL(6,2),
profit DECIMAL(12,2),
shipping_cost DECIMAL(10,2),
order_priority VARCHAR(20),
year INT
);
LOAD DATA INFILE
'C:\ProgramData\MySQL\MySQL Server 9.0\Uploads\sales_clean2.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM fact_sales;
DESCRIBE fact_sales;
SELECT
order_id,
order_date,
region,
category,
sales,
profit
FROM fact_sales
LIMIT 20;
SELECT * FROM fact_sales;
SELECT COUNT(*) FROM fact_sales;
SELECT 
MIN(order_date) AS first_order,
MAX(order_date) AS last_order
FROM fact_sales;
SELECT 
COUNT(*) AS total_rows,
SUM(order_id IS NULL) AS missing_order_id,
SUM(sales IS NULL) AS missing_sales,
SUM(profit IS NULL) AS missing_profit
FROM fact_sales;
SELECT 
ROUND(SUM(sales),2) AS total_revenue,
ROUND(SUM(profit),2) AS total_profit
FROM fact_sales;
SELECT 
COUNT(*) AS total_rows,
COUNT(DISTINCT order_id) AS unique_orders
FROM fact_sales;
SELECT
SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date
FROM fact_sales;
SELECT 
COUNT(*) AS loss_orders
FROM fact_sales
WHERE profit < 0;
SELECT
ROUND(AVG(discount)*100,2) AS avg_discount_pct,
MAX(discount)*100 AS max_discount_pct
FROM fact_sales;
SELECT
CASE 
  WHEN discount = 0 THEN 'No Discount'
  WHEN discount BETWEEN 0.01 AND 0.20 THEN 'Low Discount'
  WHEN discount BETWEEN 0.21 AND 0.50 THEN 'Medium Discount'
  ELSE 'High Discount'
END AS discount_bucket,

COUNT(*) AS orders,
ROUND(AVG(profit),2) AS avg_profit

FROM fact_sales
GROUP BY discount_bucket
ORDER BY discount_bucket;
SELECT
ROUND(AVG(shipping_cost / sales) * 100, 2) AS avg_shipping_pct,
ROUND(MAX(shipping_cost / sales) * 100, 2) AS max_shipping_pct
FROM fact_sales
WHERE sales > 0;
SELECT
ROUND(MIN(sales),2) AS min_order_value,
ROUND(MAX(sales),2) AS max_order_value,
ROUND(AVG(sales),2) AS avg_order_value
FROM fact_sales;
SELECT
COUNT(*) AS high_volume_low_profit_orders
FROM fact_sales
WHERE quantity >= 5
AND profit < 0;
SELECT
product_id,
product_name,
ROUND(SUM(profit),2) AS total_profit,
COUNT(*) AS orders
FROM fact_sales
GROUP BY product_id, product_name
HAVING total_profit < 0
ORDER BY total_profit ASC
LIMIT 10;
CREATE TABLE dim_calendar AS
SELECT DISTINCT
order_date AS date,
YEAR(order_date) AS year,
MONTH(order_date) AS month,
MONTHNAME(order_date) AS month_name,
QUARTER(order_date) AS quarter
FROM fact_sales;
SELECT COUNT(*) FROM dim_calendar;
CREATE TABLE dim_region AS
SELECT DISTINCT
region,
market,
country,
state
FROM fact_sales;
SELECT COUNT(*) FROM dim_region;
CREATE TABLE dim_product AS
SELECT DISTINCT
product_id,
product_name,
category,
sub_category
FROM fact_sales;
SELECT COUNT(*) FROM dim_product;
SELECT * FROM dim_product LIMIT 10;
CREATE TABLE dim_customer AS
SELECT DISTINCT
segment
FROM fact_sales;
SELECT * FROM dim_customer;
SELECT 
ROUND(SUM(sales),2) AS total_revenue,
ROUND(SUM(profit),2) AS total_profit,
ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM fact_sales;
SELECT 
YEAR(order_date) AS year,
MONTH(order_date) AS month,
ROUND(SUM(sales),2) AS monthly_revenue,
ROUND(SUM(profit),2) AS monthly_profit
FROM fact_sales
GROUP BY year, month
ORDER BY year, month;
SELECT 
YEAR(order_date) AS year,
MONTH(order_date) AS month,
ROUND(SUM(sales),2) AS monthly_revenue,
ROUND(SUM(profit),2) AS monthly_profit
FROM fact_sales
GROUP BY 
YEAR(order_date),
MONTH(order_date)
ORDER BY 
YEAR(order_date),
MONTH(order_date);
SELECT 
year,
month,
monthly_revenue,
ROUND(
(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month)) 
/ LAG(monthly_revenue) OVER (ORDER BY year, month) * 100, 2
) AS revenue_growth_pct
FROM (
    SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales) AS monthly_revenue
    FROM fact_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
) t;
WITH monthly_avg AS (
    SELECT 
        MONTH(order_date) AS month,
        AVG(sales) AS avg_month_sales
    FROM fact_sales
    GROUP BY MONTH(order_date)
),
overall_avg AS (
    SELECT AVG(sales) AS overall_avg_sales
    FROM fact_sales
)
SELECT 
m.month,
ROUND(m.avg_month_sales,2) AS avg_month_sales,
ROUND(o.overall_avg_sales,2) AS overall_avg_sales,
ROUND((m.avg_month_sales / o.overall_avg_sales) * 100, 2) AS seasonality_index
FROM monthly_avg m
CROSS JOIN overall_avg o
ORDER BY seasonality_index DESC;
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(sales),2) AS monthly_revenue,
    ROUND(SUM(profit),2) AS monthly_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount BETWEEN 0.01 AND 0.20 THEN 'Low Discount'
        WHEN discount BETWEEN 0.21 AND 0.50 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_bucket,
    
    COUNT(*) AS orders,
    ROUND(AVG(profit),2) AS avg_profit_per_order,
    ROUND(AVG(sales),2) AS avg_order_value
FROM fact_sales
GROUP BY discount_bucket
ORDER BY avg_profit_per_order;
SELECT 
    ROUND(AVG(shipping_cost / sales) * 100, 2) AS avg_shipping_pct,
    ROUND(MAX(shipping_cost / sales) * 100, 2) AS max_shipping_pct
FROM fact_sales
WHERE sales > 0;
SELECT 
    COUNT(*) AS high_shipping_loss_orders
FROM fact_sales
WHERE shipping_cost > profit;
SELECT 
    category,
    COUNT(*) AS orders,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(AVG(profit),2) AS avg_profit_per_order
FROM fact_sales
GROUP BY category
ORDER BY total_profit ASC;
SELECT 
    product_id,
    product_name,
    COUNT(*) AS orders,
    ROUND(SUM(profit),2) AS total_profit
FROM fact_sales
GROUP BY product_id, product_name
HAVING total_profit < 0
ORDER BY total_profit ASC
LIMIT 10;
SELECT 
    segment,
    COUNT(*) AS orders,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(AVG(profit),2) AS avg_profit_per_order
FROM fact_sales
GROUP BY segment
ORDER BY total_profit DESC;