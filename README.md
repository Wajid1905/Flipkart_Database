# Flipkart E-commerce SQL Project

![flipkart](https://github.com/user-attachments/assets/faaa5f3e-3f7e-42a0-bf79-52e27e240faa)

Welcome to my SQL project, where I analyze real-time data from **Flipkart**! This project uses a dataset of **20,000+ sales records** and additional tables for payments, products, and shipping data to explore and analyze e-commerce transactions, product sales, and customer interactions. The project aims to solve business problems through SQL queries, helping Flipkart make informed decisions.

## Table of Contents
- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Business Problems](#business-problems)
- [SQL Queries & Analysis](#sql-queries--analysis)
- [Getting Started](#getting-started)
- [Questions & Feedback](#questions--feedback)
- [Contact Me](#contact-me)

---

## Introduction

This project demonstrates essential SQL skills by analyzing e-commerce data from **Flipkart**, focusing on sales, payments, products, and customer data. Through SQL, we answer critical business questions, uncover trends, and derive actionable insights that help improve business strategies and customer experiences. The project covers different SQL techniques including **Joins**, **Group By**, **Aggregations**, and **Date Functions**.

## Project Structure

1. **SQL Scripts**: Contains code to create the database schema and write queries for analysis.
2. **Dataset**: Real-time data representing e-commerce transactions, product details, customer information, and shipping status.
3. **Analysis**: SQL queries crafted to solve business problems, each focusing on understanding e-commerce sales and performance.

---

## Database Schema

Here’s an overview of the database structure:

### 1. **Customers Table**
- **customer_id**: Unique identifier for each customer
- **customer_name**: Name of the customer
- **state**: Location (state) of the customer

### 2. **Products Table**
- **product_id**: Unique identifier for each product
- **product_name**: Name of the product
- **price**: Price of the product
- **cogs**: Cost of goods sold
- **category**: Category of the product
- **brand**: Brand name of the product

### 3. **Sales Table**
- **order_id**: Unique order identifier
- **order_date**: Date the order was placed
- **customer_id**: Linked to the `customers` table
- **order_status**: Status of the order (e.g., Completed, Cancelled)
- **product_id**: Linked to the `products` table
- **quantity**: Quantity of products sold
- **price_per_unit**: Price per unit of the product

### 4. **Payments Table**
- **payment_id**: Unique payment identifier
- **order_id**: Linked to the `sales` table
- **payment_date**: Date the payment was made
- **payment_status**: Status of the payment (e.g., Payment Successed, Payment Failed)

### 5. **Shippings Table**
- **shipping_id**: Unique shipping identifier
- **order_id**: Linked to the `sales` table
- **shipping_date**: Date the order was shipped
- **return_date**: Date the order was returned (if applicable)
- **shipping_providers**: Shipping provider (e.g., Ekart, Bluedart)
- **delivery_status**: Status of delivery (e.g., Delivered, Returned)

## Business Problems

The following queries were created to solve specific business questions. Each query is designed to provide insights based on sales, payments, products, and customer data.

### Business Problems (Easy) 
1.	`Retrieve the total sales per customer in 'Delhi' where the order status is 'Completed', only include those with total sales greater than 50,000, and order the results by total sales (use INNER JOIN between sales and customers).`
2.	`Show the total quantity sold per product in the 'Accessories' category where the total quantity sold is greater than 50 and order the results by product name (use INNER JOIN between sales and products).`
3.	`Find the total number of orders for customers from 'Maharashtra' who have spent more than 1,00,000, and order the results by the total amount spent (use INNER JOIN between sales and customers).`
4.	`Get the number of orders per product and filter to include only products that have been ordered more than 10 times, then order the results by the highest number of orders (use INNER JOIN between sales and products).`
5.	`Retrieve the number of payments made per customer where the payment status is 'Payment Successed' and group by customer, ordering by payment count (use INNER JOIN between payments and customers).`

   
### Business Problems (Medium to Hard)
1.	`Retrieve all products along with their total sales revenue from completed orders.`
2.	`List all customers and the products they have purchased, showing only those who have ordered more than two products.`
3.	`Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000.`
4.	`Retrieve the list of all orders that have not yet been shipped.`
5.	`Find the average order value per customer for orders with a quantity of more than 5.`
6.	`Get the top 5 customers by total spending on 'Accessories'.`
7.	`Retrieve a list of customers who have not made any payment for their orders.`
8.	`Find the most popular product based on total quantity sold in 2023.`
9.	`List all orders that were cancelled and the reason for cancellation (if available).`
10.	`Retrieve the total quantity of products sold by category in 2023.`
11.	`Get the count of returned orders by shipping provider in 2023.`
12.	`Show the total revenue generated per month for the year 2023.`
13.	`Find the customers who have made the most purchases in a single month.`
14.	`Retrieve the number of orders made per product category in 2023 and order by total quantity sold.`
15.	`List the products that have never been ordered (use LEFT JOIN between products and sales).`

---

## SQL Queries & Analysis

The `Actual_Business_Problem.sql` file contains all SQL queries developed for this project. Each query corresponds to a business problem and demonstrates skills in SQL syntax, data filtering, aggregation, grouping, and ordering.

---

## Getting Started

### Prerequisites
- PostgreSQL (or any SQL-compatible database)
- Basic understanding of SQL

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Wajid1905/Flipkart_Database.git
   ```
2. **Set Up the Database**:
   - Run the `Flipkart_databases.sql` script to set up tables and insert sample data.

3. **Run Queries**:
   - Execute each query in `Actual_Business_Problem.sql` to explore and analyze the data.

---

## Questions & Feedback

Feel free to add your questions and code snippets below and submit them as issues for further feedback!

**Example Questions**:
1. **Question**: Show the total revenue generated per month for the year 2023?
   <br />**Code Snippet**:
   ```sql
   SELECT
   	ordered_year,
   	ordered_month,
   	total_revenue
   FROM
   	(SELECT
   		EXTRACT(YEAR FROM order_date) as ordered_year,
   		TO_CHAR(order_date, 'Month') as ordered_month,
   		EXTRACT(MONTH FROM order_date) as month_num,
   		SUM(price_per_unit * quantity) as total_revenue
   	FROM
   		sales
   	WHERE
   		EXTRACT(YEAR FROM order_date) = 2023
   	GROUP BY 1,2,3
   	)
   ORDER BY month_num
   ```
2. **Question**: List the products that have never been ordered (using LEFT JOIN and Sub-Query Method).
   <br />**Code Snippet**:
   ```sql
   SELECT 
	* 
   FROM products
   WHERE product_id NOT IN (
							SELECT DISTINCT product_id from sales
						)
   ---- OR ----------------------

   SELECT * 
   FROM
   	products p
   LEFT JOIN
   	sales s
   ON
   	s.product_id = p.product_id
   WHERE
   	-- s.product_id IS NULL; -- We can also use this code and exclude the remaining code show below
   	p.product_id NOT IN (
   	 						SELECT DISTINCT product_id from sales
   	 					); 
   ```
3. **Question**: Find the most popular product based on total quantity sold in 2023.
   <br />**Code Snippet**:
   ```sql
   SELECT
   	s.product_id,
   	p.product_name,
   	SUM(quantity) as total_quantity_sold
   FROM
   	sales s 
   JOIN
   	products p
   ON
   	s.product_id = p.product_id
   WHERE
   	EXTRACT(YEAR FROM order_date) = 2023
   GROUP BY
   	1,2
   ORDER BY 3 DESC
   LIMIT 10;
   ```
4. **Question**: Retrieve a list of customers who have not made any payment for their orders.
   <br/>**Code Snippet**:
   ```sql
   SELECT
   	c.*,
   	s.order_id,
   	s.order_status,
   	s.product_id,
   	s.price_per_unit,
   	s.quantity	
   FROM
   	sales s
   JOIN
   	payments p
   ON
   	s.order_id = p.order_id
   JOIN
   	customers c
   ON
   	c.customer_id = s.customer_id
   WHERE
   	p.payment_status = 'Payment Failed'
   -- *********** OR Using Sub Query Method *************
   SELECT
   	c.*,
   	s.order_id,
   	s.order_status,
   	s.product_id,
   	s.price_per_unit,
   	s.quantity	
   FROM
   	sales s
   JOIN
   	customers c
   ON
   	s.customer_id = c.customer_id
   WHERE
   	s.order_id IN (
   						SELECT DISTINCT order_id from payments
   						WHERE
   							payment_status = 'Payment Failed'
   					);
   ```
5. **Question**: Find the average order value per customer for orders with a quantity of more than 5.
   <br />**Code Snippet**:
   ```sql
   SELECT 
   	s.customer_id,
   	c.customer_name,
   	-- AVG(s.price_per_unit * s.quantity) as aov
   	SUM(s.price_per_unit * s.quantity) / COUNT(s.order_id) AS average_order_value
   FROM
   	sales s
   JOIN
   	customers c
   ON
   	s.customer_id = c.customer_id
   WHERE
   	s.quantity > 5
   GROUP BY
   	1,2
   ORDER BY 3;
   ```
---

## Contact Me

📄 **[Resume](#)**  
📧 **[Email](mailto:mohammedwaghith@gmail.com)**  
📞 **Phone**: 

---

## ERD (Entity-Relationship Diagram)
![Flipkart Project Schemas](https://github.com/user-attachments/assets/262e1a47-9931-44f2-b169-4e62798ae77c)

## Notice:
All customer names and data used in this project are computer-generated using AI and random
functions. They do not represent real data associated with Flipkart or Amazon or any other entity. This
project is solely for learning and educational purposes, and any resemblance to actual persons,
businesses, or events is purely coincidental.
