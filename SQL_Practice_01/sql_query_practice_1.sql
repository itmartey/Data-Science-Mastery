-- SQL RETAIL SALE ANALYSIS - PRACTICE 1 
CREATE DATABASE sql_project_1;

-- CREATE TABLE
DROP TABLE IF EXISTS Sales_retail;
CREATE TABLE Sales_retail (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id	INT,
	gender	VARCHAR(15),
	age	INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale FLOAT

);

SELECT * FROM Sales_retail LIMIT 10;
SELECT COUNT (*) FROM Sales_retail;

ALTER TABLE Sales_retail RENAME COLUMN quantiy TO quantity;

SELECT * FROM Sales_retail
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
	customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
	category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR 
	cogs IS NULL;

-- I do not want the age column to have NULL values. Update table.
UPDATE Sales_retail
SET age = 36
WHERE age IS NULL;

DELETE FROM Sales_retail
WHERE 
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
	customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
	category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR 
	cogs IS NULL;

-- DATA EXPLORATION 

-- How many sales do we have ?
SELECT COUNT (*) as total_sales FROM Sales_retail;

-- How many Customers do we have ?
SELECT COUNT (DISTINCT customer_id) FROM Sales_retail;

--How many distinct category do we have ?
SELECT DISTINCT category FROM Sales_retail;


-- DATA ANALYSIS

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM Sales_retail
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Before that, I'd love to see the number of quantities sold under Clothing.
SELECT 
	category,
	SUM (quantity) 
FROM Sales_Retail
WHERE category = 'Clothing'
GROUP BY 1;

SELECT * 
FROM Sales_retail
	WHERE Category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4
ORDER BY transactions_id ASC; 

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS Total_Sales,
	COUNT(*) AS Total_orders
FROM Sales_retail
GROUP BY Category;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS Average_age_of_customers_in_Beauty_category
FROM Sales_retail
	WHERE Category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM Sales_retail
	WHERE total_sale>1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
 	gender,
	category,
	COUNT (transactions_id) AS total_transactions
FROM Sales_retail
GROUP BY gender,category
ORDER BY category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
		year,
		month,
		avg_sale
FROM 
(
	SELECT 
	    EXTRACT(YEAR FROM sale_date) as year,
	    EXTRACT(MONTH FROM sale_date) as month,
	    ROUND(AVG(total_sale)::numeric,2) AS avg_sale,
		SUM(total_sale) AS Total_Sale, 
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM Sales_retail
	GROUP BY 1,2
)as t1
WHERE rank = 1;

--Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT
		customer_id,
		SUM(total_sale) AS Customer_Sale,
		COUNT(Customer_id) AS Number_of_Visits
FROM Sales_retail
	GROUP BY 1
	ORDER BY 2 DESC
; --Can add a LIMIT of 10 OR 5


--Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM Sales_retail
GROUP BY category;

--END OF PRACTICE 