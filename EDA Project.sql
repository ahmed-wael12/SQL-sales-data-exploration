/*
Project: SQL Sales Data Exploration
Author: Ahmed Wael

Description:
This project analyzes sales data to extract business insights,
including KPIs, customer behavior, and product performance.

Techniques Used:
- EDA
- Aggregations (SUM, COUNT, AVG)
- Joins
- Grouping & Ranking
*/

--=========================================
-- DATABASE EXPLORATION
-- Understanding database structure (tables & columns)
--========================================

Select * From INFORMATION_SCHEMA.TABLES;
Select * From INFORMATION_SCHEMA.COLUMNS;

--=========================================
-- DIMENSIONS EXPLORATION
-- Exploring key attributes like customers and products
--=========================================

Select Distinct(Country) From dim_customers;
Select Distinct(Category) , Subcategory , product_name
From dim_products;

--==========================================
-- DATE EXPLORATION
-- Analyzing time range of orders and customer ages
--==========================================

Select
Min(Order_date) as First_Order_Date,
Max(Order_date) as Last_Order_Date,
DATEDIFF(Year,Min(Order_date),Max(Order_date)) as Order_Range_Year
From Fact_sales;

Select 
Min(Birthdate) as Oldest_Birthdate,
DATEDIFF(Year, Min(Birthdate), GetDate()) as Oldest_Age,
Max(Birthdate) as Oldest_Birthdate,
DATEDIFF(Year, Max(Birthdate), GetDate()) as Youngest_Age
From dim_customers;

-- =========================================
-- KPI & MEASURES CALCULATION
-- Calculating key business metrics
-- =========================================

Select Sum(sales_amount) as Total_Sales From Fact_sales;
Select Sum(quantity) as Total_Quatity From Fact_sales;
Select Avg(Price) as Avg_Price From Fact_sales;
Select Count(Distinct order_number) as Total_Orders From Fact_sales;
Select Count(product_key) as Total_Prodacts From dim_products;
Select Count(customer_key) as Total_Customers From dim_customers;
Select Count(Distinct customer_key) as Total_Customers From Fact_sales;

-- =========================================
-- FINAL KPI REPORT
-- Combining all KPIs into one unified result
-- for business overview
-- =========================================

Select 'Total Sales' as Measure_Name , Sum(sales_amount) as Measure_Value From Fact_sales
Union All
Select 'Total Quantity', Sum(quantity) From Fact_sales
Union All
Select 'Average Price', Avg(Price) From Fact_sales
Union All
Select 'Total Nr. Orders', Count(Distinct order_number) From Fact_sales
Union All
Select 'Total Nr. Products', Count(product_key) From dim_products
Union All
Select 'Total Nr. Customers', Count(customer_key) From dim_customers

-- =========================================
-- MAGNITUDE ANALYSIS
-- Understanding data distribution across dimensions
-- =========================================

Select 
Country,
Count(customer_key) as Total_Customers
From dim_customers
Group by Country
Order by Total_Customers Desc;

Select 
Gender,
Count(customer_key) as Total_Customers
From dim_customers
Group by gender
Order by Total_Customers Desc;

Select 
Category,
Count(product_key) as Total_Products
From dim_products
Group by Category
Order by Total_Products Desc;

Select 
Category,
Avg(Cost) as Total_Costs
From dim_products
Group by Category
Order by Total_Costs Desc;

Select 
p.Category,
Sum(f.sales_amount) as Total_Revenue
From fact_sales f 
Join dim_products p
on f.product_key = p.product_key
Group by p.Category
Order by Total_Revenue Desc;

Select 
c.customer_key,
c.first_name,
c.last_name,
Sum(f.sales_amount) as Total_Revenue
From fact_sales f 
Join dim_customers c
on f.product_key = c.customer_key
Group by c.customer_key,c.first_name,c.last_name
Order by Total_Revenue Desc;

Select 
c.country,
Sum(f.quantity) as Total_Sold_Items
From fact_sales f 
Join dim_customers c
on f.customer_key = c.customer_key
Group by c.country
Order by Total_Sold_Items Desc;

-- =========================================
-- RANKING ANALYSIS
-- Identifying top and bottom performers
-- =========================================

-- Identify top customers contributing the highest revenue
Select Top 5
p.subcategory,
Sum(f.sales_amount) as Total_Revenue
From fact_sales f 
Join dim_products p
on f.product_key = p.product_key
Group by p.subcategory
Order by Total_Revenue Desc;

-- Find lowest-performing products based on revenue
Select Top 5
p.product_name,
Sum(f.sales_amount) as Total_Revenue
From fact_sales f 
Join dim_products p
on f.product_key = p.product_key
Group by p.product_name
Order by Total_Revenue Asc;

--Top 10 Customer who have highest Revenue
Select Top 10
c.customer_key,
c.first_name,
c.last_name,
Sum(f.sales_amount) as Total_Revenue
From fact_sales f 
Join dim_customers c
on f.customer_key = c.customer_key
Group by c.customer_key,c.first_name,c.last_name
Order by Total_Revenue Desc;

-- Identify customers with lowest orders
Select Top 10
c.customer_key,
c.first_name,
c.last_name,
Count(Distinct Order_number) as Total_Order
From fact_sales f 
Join dim_customers c
on f.customer_key = c.customer_key
Group by c.customer_key,c.first_name,c.last_name
Order by Total_Order Asc;