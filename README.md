# Retail Sales Exploratory Data Analysis (EDA) | SQL Project

## Project Overview

**Project Title**: Retail Sales Exploratory Data Analysis (EDA) 
**Level**: Intermediate  
**Database**: `BR2`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `BR2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, transaction date, transaction time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE BR2;

CREATE TABLE retail_sales
(
Transactions_ID INT primary key,
Transaction_date date,
Transaction_time time,
Customer_ID INT,
Age INT, 
Gender varchar(15),
Product_Category varchar(50),
Quantity INT,
CP_Per_Unit float,
SP_Per_Unit float, 
Total_Sale float
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Data Cleaning

SELECT * FROM retail_sales
WHERE
      Transaction_date is null or Transaction_time is null or customer_id is null or gender is null or age is null or Product_Category is null or Quantity is null or 
      CP_Per_Unit is null or SP_Per_Unit is null or Total_Sale is null;

DELETE FROM retail_sales
WHERE
      Transaction_date is null or Transaction_time is null or customer_id is null or gender is null or age is null or Product_Category is null or Quantity is null or 
      CP_Per_Unit is null or SP_Per_Unit is null or Total_Sale is null;

-- Exploration

select count(transaction_id) from retail_sales; -- 1987
-- how many customers we have -->
select count(distinct customer_id) from Retail_Sales; -- 155
-- how many categories we have -->
select count(distinct product_category) from Retail_Sales;
select product_category, count(product_category) from Retail_Sales group by product_category order by count(product_category) desc;
```

### 3. Data Analysis & Findings (Business Key Problems and Answers)

The following SQL queries were developed to answer specific business questions:

1. **Write an sql query to retrieve all columns for sales made on 2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE transaction_date = '2022-11-05';
```

2. **Write an sql query to calculate Total Sales on '2022-11-05'**:
```sql
select transaction_date as 'Date of Transaction', sum(total_sale) as 'Total Sales'
from Retail_Sales
where transaction_date = "2023-11-05"
group by 1; 
```

3. **Write an sql query retrieve all transactions for the "clothing" category, and the quantity sold is more than 3 in the month of nov-2022**:
```sql
select * from Retail_Sales
where product_category = "clothing" and quantity > 3 and monthname(transaction_date) = 'november'
order by transaction_id asc;

-- second method -->

select * from Retail_Sales
where product_category = "clothing" and quantity > 3 and transaction_date between '2022-11-01' and '2022-11-30'
order by transaction_id asc;
```

4. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select product_category as 'Product_Category', sum(total_sale) as 'Net Sales Amount', count(transaction_id) as 'Total no. of orders'
from Retail_Sales group by 1;
```

5. **Write an sql query to find average age of customers who purchased items from the 'Beauty' category**:
```sql
select product_category as 'Product_Category', round(avg(age),3) as 'Average Age of Customers'
from Retail_Sales 
where product_category = 'Beauty' group by 1;
```

6. **Write an sql query to find all the transactions where total sale is greater than 1000**:
```sql
select * from Retail_Sales
where total_sale > 1000
order by transaction_id asc;

```

7. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:
```sql
select product_category as 'Product_Category', Gender, count(transaction_id) as 'Total Transactions'
from Retail_Sales
group by 1, 2
order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **YouTube**: [Subscribe to my channel for tutorials and insights](https://www.youtube.com/@zero_analyst)
- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/zero_analyst/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/najirr)
- **Discord**: [Join our community to learn and grow together](https://discord.gg/36h5f2Z5PK)

Thank you for your support, and I look forward to connecting with you!
