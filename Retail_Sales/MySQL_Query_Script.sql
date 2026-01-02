Create Database BR2;
use BR2;
-- create table
Drop table if exists Retail_Sales;
Create table Retail_Sales (Transactions_ID INT primary key, Transaction_date date, Transaction_time time, ﻿Customer_ID INT, Age INT, 
						   Gender varchar(15), Product_Category varchar(50), Quantity INT, CP_Per_Unit float, SP_Per_Unit float, 
						   Total_Sale float);
-- alter table Retail_Sales change Product_Category Product_Category varchar(50); 
select * from Retail_Sales;
-- SET sql_safe_updates = 0;
-- Import data
select count(*) from retail_sales;

-- data cleaning

select * from Retail_Sales 
where Transaction_date is null
or 
Transaction_time is null or customer_id is null or gender is null or age is null or Product_Category is null or Quantity is null or 
CP_Per_Unit is null or SP_Per_Unit is null or Total_Sale is null;

delete from Retail_Sales where Transaction_date is null or Transaction_time is null or customer_id is null or gender is null 
or age is null or Product_Category is null or Quantity is null or  CP_Per_Unit is null or SP_Per_Unit is null or Total_Sale is null;

-- data exploration

-- how many transactions -->
select count(transaction_id) from retail_sales; -- 1987
-- how many customers we have -->
select count(distinct customer_id) from Retail_Sales; -- 155
-- how many categories we have -->
select count(distinct product_category) from Retail_Sales;
select product_category, count(product_category) from Retail_Sales group by product_category order by count(product_category) desc;

-- Data Analysis (Business Key Problems and answers)

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 write an sql query to calculate Total Sales on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 write an sql query to retrieve all columns for sales made on 2022-11-05 -->
select * from Retail_Sales where transaction_date = "2023-11-22";

-- Q.2 write an sql query to calculate Total Sales on '2022-11-05'
select transaction_date as 'Date of Transaction', sum(total_sale) as 'Total Sales' from Retail_Sales where transaction_date = "2023-11-05"
group by 1; 
/* select * from (select * from Retail_Sales where transaction_date = "2023-11-22") as alias1, 
(select transaction_date, sum(total_sale) from Retail_Sales where transaction_date = "2023-11-22" group by transaction_date) as alias2; */ 

-- Q.3 write an sql query retrieve all transactions for the "clothing" category, and the quantity sold is more than 3 in the month of nov-2022 -->
select * from Retail_Sales where product_category = "clothing" and quantity > 3 and monthname(transaction_date) = 'november'
order by transaction_id asc;
-- second method -->
select * from Retail_Sales where  product_category = "clothing" and quantity > 3 and transaction_date between '2022-11-01' and '2022-11-30'
order by transaction_id asc;
-- select monthname(transaction_date) from Retail_Sales;
-- select date_format(transaction_date, '%M') as 'Month' from Retail_Sales;

-- Q.4 write an sql query to calculate total sales for each category -->
select product_category as 'Product_Category', sum(total_sale) as 'Net Sales Amount', count(transaction_id) as 'Total no. of orders'
from Retail_Sales group by 1;

-- Q.5 write an sql query to find average age of customers who purchased items from the 'Beauty' category -->
select product_category as 'Product_Category', round(avg(age),3) as 'Average Age of Customers' from Retail_Sales 
where product_category = 'Beauty' group by 1;

-- Q.6 write an sql query to find all the transactions where total sale is greater than 1000 -->
select * from Retail_Sales where total_sale > 1000 order by transaction_id asc;

-- Q.7 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category -->
select product_category as 'Product_Category', Gender, count(transaction_id) as 'Total Transactions' from Retail_Sales
group by 1, 2 order by 1;  

-- Q.8 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year -->
-- 1st Method -->

select year(transaction_date) as 'Year', monthname(transaction_date) as 'Month', month(transaction_date) as 'Month No.', 
round(avg(total_sale),3) as 'Average Sales Amount', sum(total_sale) as 'Net Sales Amount' 
from Retail_Sales group by 1,2,3 order by 1,3; -- in mysql - works both; In postgresql - select extract(year from col_name) as year;

-- Best selling month of yeach year based on net sales amount - 
select * from (select year(transaction_date) as 'Year', monthname(transaction_date) as 'Month', month(transaction_date) as 'Month No.', 
round(avg(total_sale),3) as 'Average Sales Amount', sum(total_sale) as 'Net Sales Amount' 
from Retail_Sales group by 1,2,3 order by 5 desc) as alias1 limit 2;


-- 2nd Method (by using rank (windows function)) -->

select year(transaction_date) as 'Year', monthname(transaction_date) as 'Month', month(transaction_date) as 'Month No.', 
round(avg(total_sale),3) as 'Average Sales Amount', sum(total_sale) as 'Net Sales Amount',
rank() over(partition by year(transaction_date) order by sum(total_sale) desc) as 'rank'
from Retail_Sales group by 1,2,3; -- this query gives rank of each month in each year and unless used 'order by', orders them according to the rank.

-- Best selling month of yeach year based on net sales amount - 
select Year, Month, Net_Sales_Amount from (select year(transaction_date) as 'Year', monthname(transaction_date) as 'Month', month(transaction_date) as 'Month No.', 
round(avg(total_sale),3) as 'Average Sales Amount', sum(total_sale) as Net_Sales_Amount,
rank() over(partition by year(transaction_date) order by sum(total_sale) desc) as 'Ranks'
from Retail_Sales group by 1,2,3) as alias1 where ranks = '1';


-- Q.9 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id as 'Customer ID', sum(total_sale) as 'Total Sales' from Retail_Sales
group by 1 order by 2 desc limit 5;

-- Q.10 Write a SQL query to find the number of unique customers who purchased items from each category
select Product_Category as 'Product_Category', count(distinct customer_id) as 'Total Customers' from Retail_Sales 
group by 1 order by 1;


-- Q.11 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) -->
select
case
when hour(transaction_time) < 12 then 'Morning'
when hour(transaction_time) between 12 and 17 then 'Afternoon' 
else 'Evening'
end as 'Shift', count(transaction_id) from Retail_Sales 
group by 1;

-- now for particular dates the shiftwise sales are -->
select transaction_date as 'Transaction Date',
case
when hour(transaction_time) < 12 then 'Morning'
when hour(transaction_time) between 12 and 17 then 'Afternoon' 
else 'Evening'
end as 'Shift', count(transaction_id) from Retail_Sales 
group by 1, 2 order by 1;

-- Another Method using CTE(common table expression as it's complicated to apply group by in columns in the same complex query
with shift_wise_sales
as (select *, case
when hour(transaction_time) < 12 then 'Morning'
when hour(transaction_time) between 12 and 17 then 'Afternoon' 
else 'Evening'
end as 'Shift', count(transaction_id) from Retail_Sales group by 1
)
select Shift, count(*) as 'Total Orders' from shift_wise_sales group by 1;

-- now for particular dates the shiftwise sales are -->
with shift_wise_sales
as (select *, case
when hour(transaction_time) < 12 then 'Morning'
when hour(transaction_time) between 12 and 17 then 'Afternoon' 
else 'Evening'
end as 'Shift', count(transaction_id) from Retail_Sales group by 1
)
select transaction_date as 'Transaction Date', Shift, count(*) as 'Total Orders' from shift_wise_sales group by 1,2 order by 1;
 
-- End of Project













