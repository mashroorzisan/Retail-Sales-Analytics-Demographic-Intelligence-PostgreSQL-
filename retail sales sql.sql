-- sql retial sales analysis
CREATE DATABASE sql_project_sales;

-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
			transactions_id INT,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantity INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
);

-- STEP:1 LOOK FOR NULL for each column
-- SELECT * FROM retail_sales
-- WHERE transactions_id IS NULL;

-- SELECT * FROM retail_sales
-- WHERE sale_date IS NULL;

-- SELECT * FROM retail_sales
-- WHERE sale_time IS NULL;

-- SELECT * FROM retail_sales
-- WHERE customer_id IS NULL;

-- SELECT * FROM retail_sales
-- WHERE gender IS NULL;

-- SELECT * FROM retail_sales
-- WHERE age IS NULL;

-- SELECT * FROM retail_sales
-- WHERE category IS NULL;

-- SELECT * FROM retail_sales
-- WHERE quantity IS NULL;

-- SELECT * FROM retail_sales
-- WHERE price_per_unit IS NULL;

-- SELECT * FROM retail_sales
-- WHERE cogs IS NULL;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- DELETING NULL VALUES
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;



-- 2. DATA EXPLORATION
SELECT * FROM retail_sales;
-- 2.1. HOW MANY SALES DO WE HAVE?
SELECT COUNT(*) AS total_sales FROM retail_sales;
-- 2.2 HOW MANY UNIQUE CUSTOMERS DO WE HAVE?
SELECT COUNT(DISTINCT customer_id) unique_customers_no FROM retail_sales;
-- 2.3 HOW MANY UNIQUE CATEGORIES DO WE HAVE?
SELECT COUNT(DISTINCT category) AS unique_categories FROM retail_sales;

-- 3. DATA ANALYSIS & BUSINESS KEY PROBLEMS WITH ANSWERS
-- My Analysis & Findings
-- BASIC ANALYSIS
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
	category,
	CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN 'NOV' ELSE 'OTHERS' END AS  month,
	SUM(quantity) quantity
FROM retail_sales
WHERE sale_date>='2022-11-01' AND sale_date<'2022-12-01'
GROUP BY 1,2 
HAVING category = 'Clothing' AND SUM(quantity) > 10;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN 'NOV' ELSE 'OTHERS' END AS  month,
	SUM(quantity) quantity,
	SUM(total_sale) AS toal_sales
FROM retail_sales
WHERE sale_date>='2022-11-01' AND sale_date<'2022-12-01'
GROUP BY 1,2 ;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT   
	category,
	ROUND(AVG(age))::NUMERIC
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM retail_sales
WHERE total_sale> 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	gender,
	category,
	COUNT(transactions_id) total_transaction
FROM retail_sales
GROUP BY gender, category;
---------alternative solution with window function------------
WITH transactions as(
SELECT
	gender,
	category,
	COUNT(transactions_id) OVER(PARTITION BY gender, category) total_transaction
FROM retail_sales
)
SELECT DISTINCT *
FROM transactions
ORDER BY gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH average_sales as(
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	ROUND(AVG(total_sale)) AS avg_sale
	
FROM retail_sales
GROUP BY year, month
),
ranked_sales AS(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) Rnk
FROM average_sales
)
SELECT *
FROM ranked_sales 
WHERE Rnk=1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

