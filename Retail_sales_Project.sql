-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project1;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
------------
--Data Cleaning
--Dealing with null values
DELETE FROM retail_sales
where
 transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-------------------------
--EDA

SELECT COUNT(*) as total_sale
FROM retail_sales

SELECT Count(distinct customer_id) as total_customers
from retail_sales

SELECT Count(distinct category) as total_category
from retail_sales

-----
--Solving business problems 
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


--Q1
select * 
from retail_sales
where sale_date = '2022-11-05'

--Q2
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
--Q3
SELECT category, sum(quantity*price_per_unit) as total_sales
from retail_sales
group by 1

SELECT category, sum(total_sale), count(*) as total_orders
from retail_sales
group by 1

--Q4

select category, avg(age) as average_age
from retail_sales
where category = 'Beauty'
group by 1

--Q5

select *
from retail_sales
where total_sale>1000
--
--Q6

select count(transaction_id),category,gender
from retail_sales
group by 2,3


--Q7
with CTE as (
	SELECT 
	EXTRACT(YEAR from sale_date) as YEAR,
		EXTRACT(MONTH from sale_date) as MONTH,
		
		avg(total_sale) as average_sales,
		RANK() over(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY avg(total_sale) DESC) as rnk
	from retail_sales
	group by 1,2
	order by 1,2
)

select year,month,average_sales
from cte
where rnk =1

--Q8
SELECT
	customer_id,
	sum(total_sale) as totaal_sales
from retail_sales
group by 1
order by 2 desc
limit 5

--Q9

SELECT 
	count(DISTINCT customer_id), category
from retail_sales
group by 2

--Q10
with hourly_sale as(
SELECT *,
	case WHEN EXTRACT(HOUR from sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		WHEN EXTRACT(HOUR from sale_time) >17 THEN 'Evening'
	end as shift
from retail_sales
	)
select shift, count(*) as total_orders
from hourly_sale
group by 1














