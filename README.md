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
);
#### Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
```sql
SELECT 
	category,
	CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN 'NOV' ELSE 'OTHERS' END AS  month,
	SUM(quantity) quantity
FROM retail_sales
WHERE sale_date >= '2022-11-01' AND sale_date < '2022-12-01'
GROUP BY 1,2 
HAVING category = 'Clothing' AND SUM(quantity) > 10;
