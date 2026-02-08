# Retail Sales Intelligence & Trend Analysis (SQL)

## 📌 Project Overview
This project focuses on transforming raw retail transaction data into actionable business insights. Using **PostgreSQL**, I performed comprehensive data cleaning, exploratory data analysis (EDA), and developed advanced SQL queries to solve real-world business problems, including customer segmentation and sales trend analysis.

## 🎯 Key Objectives
* **Data Pipeline Construction**: Schema design and optimized data ingestion.
* **Data Quality Assurance**: Advanced cleaning techniques to handle null values and data inconsistencies.
* **Business Intelligence**: Utilizing Window Functions, CTEs, and Aggregations to derive KPIs.
* **Customer Analytics**: Segmenting demographics to understand purchasing behavior.

## 🛠️ Tech Stack
* **Database**: PostgreSQL
* **Tool**: pgAdmin4 / DBeaver
* **Language**: SQL (Advanced)

---

## 🚀 Analysis Roadmap

### 1. Database Setup
```sql
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
);```
---
### 2. Data Cleaning & QA
Identified and handled records with missing values to ensure data integrity for downstream analysis.

SQL
-- Checking for NULL values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR total_sale IS NULL;

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
3. Exploratory Data Analysis (EDA)
SQL
-- Total sales count
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customer count
SELECT COUNT(DISTINCT customer_id) unique_customers_no FROM retail_sales;

-- Unique categories
SELECT COUNT(DISTINCT category) AS unique_categories FROM retail_sales;
4. Business Analysis & Findings
Q.1 Retrieve all columns for sales made on '2022-11-05'
SQL
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';
Q.2 Retrieve 'Clothing' transactions with quantity > 10 in Nov-2022
SQL
SELECT 
	category,
	CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN 'NOV' ELSE 'OTHERS' END AS month,
	SUM(quantity) quantity
FROM retail_sales
WHERE sale_date >= '2022-11-01' AND sale_date < '2022-12-01'
GROUP BY 1,2 
HAVING category = 'Clothing' AND SUM(quantity) > 10;
Q.3 Calculate total sales for each category
SQL
SELECT 
	category,
	CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN 'NOV' ELSE 'OTHERS' END AS month,
	SUM(quantity) quantity,
	SUM(total_sale) AS toal_sales
FROM retail_sales
WHERE sale_date >= '2022-11-01' AND sale_date < '2022-12-01'
GROUP BY 1,2 ;
Q.4 Find the average age of customers in the 'Beauty' category
SQL
SELECT    
	category,
	ROUND(AVG(age))::NUMERIC
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
Q.5 Find all transactions where total_sale > 1000
SQL
SELECT * FROM retail_sales WHERE total_sale > 1000;
Q.6 Total number of transactions by gender in each category
SQL
-- Standard Group By
SELECT
	gender,
	category,
	COUNT(transactions_id) total_transaction
FROM retail_sales
GROUP BY gender, category;

-- Alternative solution with window function
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
Q.7 Find the best selling month in each year
SQL
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
SELECT * FROM ranked_sales WHERE Rnk = 1;
Q.8 Find the top 5 customers based on highest total sales
SQL
SELECT  
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
Q.9 Unique customer count per category
SQL
SELECT  
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;
Q.10 Create shifts and count orders per shift
SQL
WITH hourly_sale AS (
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
GROUP BY shift;
📈 Key Findings
Customer Segmentation: The analysis reveals that the 'Beauty' category attracts a specific age demographic, allowing for targeted marketing.

Peak Sales Periods: High-value transactions and peak order volumes are concentrated in the evening shifts and during specific months like November.

Customer Loyalty: A small group of high-value customers contributes significantly to total revenue, suggesting a need for personalized retention programs.

🏁 Conclusion
This project serves as a comprehensive introduction to data analysis using SQL. By completing the full workflow—from database setup and data cleaning to complex business queries—I have demonstrated the ability to extract meaningful insights from raw data. These skills are essential for data-driven decision-making in any retail or business environment.
