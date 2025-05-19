-- Create Tables
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR (15),
				age	INT,
				category VARCHAR (15),
				quantiy	INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

-- CHECKING THE DATASET
SELECT * FROM retail_sales
LIMIT 10

SELECT
	COUNT(*)
FROM retail_sales

-- EXPLORING THE DATASET
-- a) NULL VALUES 

SELECT * FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

-- EXPLORE DIMENSIONS OF THE DATASET
-- a) CATEGORIES
SELECT DISTINCT gender, category FROM retail_sales
ORDER BY 1, 2




-- b) DATE AND TIME 
SELECT 
	MIN (sale_date) AS first_sale_date,
	MAX (sale_date) AS last_sale_date,
	EXTRACT(MONTH FROM AGE(MAX(sale_date), MIN(sale_date))) AS month_diff
FROM retail_sales;


-- Explore measures 
-- a) Key metrics and big numbers 

SELECT 
COUNT (DISTINCT customer_id) AS number_of_customers, -- Number of Customers
AVG(quantiy) AS avg_quantity_per_sale, -- average quantity per a sale
AVG(price_per_unit) AS avg_price_per_unit, -- average price per unit sales
MAX(price_per_unit) AS max_price_per_unit,
MIN(price_per_unit) AS min_price_per_unit, -- highest and lowest prices per sales
SUM (total_sale) AS total_total_sale, -- total sales 
SUM (cogs) AS total_cogs,-- total cogs
SUM (total_sale)-SUM (cogs) as total_profit-- net profit (sales - cogs)
FROM retail_sales;

-- b) Exploring magnitudes by combining measures by categories to gain insights 
-- Gender with the most sales
SELECT gender, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY gender
ORDER BY total_sales DESC
LIMIT 1;

-- Top 10 dates with the most sales
SELECT sale_date, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY total_sales DESC
LIMIT 10;

-- Busiest Months
SELECT 
    DATE_PART('month', sale_date) AS month, 
    COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY month
ORDER BY transaction_count DESC;

-- the most sold category
SELECT category, COUNT(*) AS sales_count
FROM retail_sales
GROUP BY category
ORDER BY sales_count DESC;

-- Top 5 sales age 
SELECT age, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY age
ORDER BY total_sales DESC
LIMIT 5;

-- Top 5 Category with the most sales
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Categories with the most sold quantity
SELECT category, SUM(quantiy) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_quantity DESC;

-- Top 5 Category costing the most (COGS)
SELECT category, SUM(cogs) AS total_cogs
FROM retail_sales
GROUP BY category
ORDER BY total_cogs DESC
;

-- Average age for costumer purchasing "Beauty" Category
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Sum of "Electronics" total_sales by gender
SELECT gender, SUM(total_sale) AS total_sales
FROM retail_sales
WHERE category = 'Electronics'
GROUP BY gender
ORDER BY total_sales DESC;

-- Average expenditure per transaction for each gender
SELECT gender, AVG(total_sale) AS avg_expenditure
FROM retail_sales
GROUP BY gender;

-- Most Busy Time of the Day (Morning, Afternoon, Evening)
SELECT 
    CASE 
        WHEN sale_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY time_period
ORDER BY transaction_count DESC;

-- Sales in Month November 2022
SELECT SUM(total_sale) AS total_sales
FROM retail_sales
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Top 5 customers with the most sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Top 5 customers with the most sales per transactions
SELECT customer_id, AVG(total_sale) AS avg_sales_per_transaction
FROM retail_sales
GROUP BY customer_id
ORDER BY avg_sales_per_transaction DESC
LIMIT 5;

-- Customers who purchased items from more than 1 category
SELECT customer_id, COUNT(DISTINCT category) AS unique_categories
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) > 1;

-- Count number of Customers who purchased items from more than 1 category
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM retail_sales
    GROUP BY customer_id
    HAVING COUNT(DISTINCT category) > 1
) AS multi_category_customers;

-- Costomers with more than 1 transaction
SELECT customer_id, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Count number of Costomers with more than 1 transaction
SELECT COUNT(*) AS customer_count2
FROM (
    SELECT customer_id
    FROM retail_sales
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS multi_category_customers;

