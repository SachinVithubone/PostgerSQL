DROP TABLE IF EXISTS RETAIL_SALES;

create table retail_sales
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(20),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		);

-- import data uisng tool and check the data is loaded or not
SELECT *FROM retail_sales;

-- ******************** Data Validations ********************
-- count the number of records
select count(*)
from retail_sales;

-- check if having any column null values
SELECT *FROM retail_sales
where transactions_id IS NULL;

SELECT *FROM retail_sales
where   
	transactions_id IS NULL
			or
	sale_date IS NULL 
			OR
	sale_time IS NULL 
	  		OR
	customer_id IS NULL
			OR
    gender IS NULL
			OR
	--age IS NULL
	--		OR
	category IS NULL
			OR
	quantiy IS NULL
			OR
    price_per_unit IS NULL
			OR
	cogs IS NULL
			OR
	total_sale IS NULL;
	

-- ******************** Data cleaning ********************

delete from retail_sales
where   
	transactions_id IS NULL
			or
	sale_date IS NULL 
			OR
	sale_time IS NULL 
	  		OR
	customer_id IS NULL
			OR
    gender IS NULL
			OR
	--age IS NULL
	--		OR
	category IS NULL
			OR
	quantiy IS NULL
			OR
    price_per_unit IS NULL
			OR
	cogs IS NULL
			OR
	total_sale IS NULL;

-- ******************** Data Expolaration ********************

Q1. Check how many sales we have?
select count(*) as Total_sales from retail_sales;

--Q2. How many unique customer we have.
select count(distinct customer_id) as number_Of_customer from retail_sales;

--Q3. check how many category we have.
select  distinct category as number_Of_category from retail_sales;

-- ******************** Data Analysis and Business problem ********************
--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity 
--    sold is more than 4 in the month of Nov-2022:
--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.:
--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--Q6. Write a SQL query to find the total number of transactions (transaction_id) made 
--	  by each gender in each category.:
--Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
--Q9. Write a SQL query to find the number of unique customers who purchased items from each category.:
--Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, 
--     Afternoon Between 12 & 17, Evening >17):

--

--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT 
*FROM retail_sales
where sale_date = '2022-11-05';


--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity 
--    sold is more than 3 in the month of Nov-2022:
SELECT 
*FROM retail_sales
WHERE category = 'Clothing' 
	  AND 
	  quantiy > 3
	  AND
	  sale_date BETWEEN '2022-11-05' AND  '2022-11-30';
--

--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category, 
	sum(total_sale) AS total_sales_by_each_category
from retail_sales
group by 
	category;

SELECT 
	category, sum(total_sale) AS total_sales_by_each_category,
	count(*) AS total_orders
from retail_sales
group by 
	category;

--
--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  
	ROUND(AVG(age), 2) AS average_age_of_customer  -- ROUND function make the decimal point leass
FROM retail_sales
where category = 'Beauty';
--

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
*FROM retail_sales
where total_sale > 1000;

--
--Q6. Write a SQL query to find the total number of transactions (transaction_id) made 
--	  by each gender in each category.
SELECT 
	gender, 
	category, 
	count(*) AS transaction_by_gender  --in count(transactions_id) as like
from retail_sales
group by 
	gender, 
	category;

--
--Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	EXTRACT(YEAR from sale_date) as years,
	EXTRACT(MONTH from sale_date) as months,
	AVG(total_sale) AS average_sale 
from retail_sales
group by 
	1,
	2
order by  1,3 desc;

select sale_date, avg(total_sale) as average_sale
from retail_sales
group by sale_date

--
--Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

select 
	customer_id, 
	sum(total_sale) AS higest_total_sales
from retail_sales
group by customer_id
order by 
	higest_total_sales desc
limit 5;
--
--Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	CATEGORY,
	COUNT(DISTINCT (CUSTOMER_ID)) AS UNIQUE_CUSTOMER
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

--
--Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, 
--     Afternoon Between 12 & 17, Evening >17)
select *from retail_sales;


--Select  SUM(total_sale) AS total_sales_each_shift,
Select  COUNT(*) AS total_order_each_shift,
		CASE
			WHEN EXTRACT (HOUR FROM sale_time)  < 12  THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time)  BETWEEN 12  AND 17 THEN 'Afternoon'
--			WHEN sale_time <= '12:00:00' and sale_time >= '17:00:00' THEN 'Afternoon'
			Else 'Evening'
		END AS shift_time
from retail_sales
group by shift_time;

------------------- another way

with hourly_sales
AS 
(
Select  
		CASE
			WHEN EXTRACT (HOUR FROM sale_time)  < 12  THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time)  BETWEEN 12  AND 17 THEN 'Afternoon'
			Else 'Evening'
		END AS shift_time
from retail_sales
) 
select shift_time,
	count(*) as total_order
from hourly_sales
group by shift_time;

-- End of all business problem.