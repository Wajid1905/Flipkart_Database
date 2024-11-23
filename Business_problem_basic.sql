-- Joins - SQL (Inner, LEFT, RIGHT, Full)
-- 1.	Retrieve a list of all customers with their corresponding product names they ordered (use an INNER JOIN between customers and sales tables).
-- 2.	List all products and show the details of customers who have placed orders for them. Include products that have no orders (use a LEFT JOIN between products and sales tables).
-- 3.	List all orders and their shipping status. Include orders that do not have any shipping records (use a LEFT JOINbetween sales and shippings tables).
-- 4.	Retrieve all products, including those with no orders, along with their price. Use a RIGHT JOIN between the products and sales tables.
-- 5.	Get a list of all customers who have placed orders, including those with no payment records. Use a FULL OUTER JOIN between the customers and payments tables.

-- 1.	Retrieve a list of all customers with their corresponding 
--		product names they ordered (use an INNER JOIN between customers and sales tables).

SELECT 
	c.*,
	s.order_date,
	p.brand,
	p.product_name,
	s.order_status,
	p.price,
	s.quantity,
	(p.price * s.quantity) as total_order_value
FROM
	customers c
JOIN
	sales s 
ON 
	c.customer_id = s.customer_id
JOIN
	products p
ON
	s.product_id = p.product_id;


-- 2.	List all products and show the details of customers who have placed orders for them. 
--		Include products that have no orders (use a LEFT JOIN between products and sales tables).

SELECT 
	p.*,
	s.order_id,
	s.order_date,
	s.order_status,
	s.quantity,
	s.customer_id,
	c.customer_name,
	c.state	
FROM
	products p
LEFT JOIN
	sales s
ON
	p.product_id = s.product_id
LEFT JOIN
	customers c
ON	s.customer_id = c.customer_id
--WHERE 	s.order_id IS NULL; 


-- 3.	List all orders and their shipping status. Include orders that do not have any shipping records 
--		(use a LEFT JOINbetween sales and shippings tables).

SELECT *
FROM
	sales s
LEFT JOIN
	shippings sp
ON
	s.order_id = sp.order_id
-- WHERE sp.order_id IS NULL;  -- This will show the orders which are not shipped (reason : order were cancelled)

	
-- 4.	Retrieve all products, including those with no orders, along with their price. 
--		Use a RIGHT JOIN between the products and sales tables.

SELECT
	*
FROM
	sales s
RIGHT JOIN
	products p
ON
	p.product_id = s.product_id;
--where s.order_id IS NULL;         -- 4.	This will retrieve all products, including those with no orders 

-- 5.	Get a list of all customers who have placed orders, including those with no payment records. 
--		Use a FULL OUTER JOIN between the customers and payments tables.

SELECT
	*
FROM
	sales s
FULL JOIN
	payments p
ON
	s.order_id = p.order_id
FULL JOIN
	customers c
ON	
	c.customer_id = s.customer_id;


-- Joins + Where Clause

-- ●	Find the total number of completed orders made by customers from the state 'Delhi' (use INNER JOIN between customers and sales and apply a WHERE condition).
-- ●	Retrieve a list of products ordered by customers from the state 'Karnataka' with price greater than 10,000 (use INNER JOIN between sales, customers, and products).
-- ●	List all customers who have placed orders where the product category is 'Accessories' and the order status is 'Completed' (use INNER JOIN with sales, customers, and products).
-- ●	Show the order details of customers who have paid for their orders, excluding those who have cancelled their orders (use INNER JOIN between sales and payments and apply WHERE for order_status).
-- ●	Retrieve products ordered by customers who are in the 'Gujarat' state and whose total order price is greater than 15,000 (use INNER JOIN between sales, customers, and products).

	
-- ●	Find the total number of completed orders made by customers from the state 
--	'Delhi' (use INNER JOIN between customers and sales and apply a WHERE condition).

SELECT
	*
FROM 
	Sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
WHERE
	c.state = 'Delhi';


--  Retrieve a list of products ordered by customers from the state 'Karnataka' 
--with price greater than 10,000 (use INNER JOIN between sales, customers, andproducts)

SELECT
	*
FROM 
	Sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
JOIN
	products p
ON
	s.product_id = p.product_id
WHERE
	c.state = 'Karnataka'
	AND
	p.price > 10000;
--	s.price_per_unit * s.quantity > 10000;


-- List all customers who have placed orders where the product category is 'Accessories'
-- and the order status is 'Completed' (use INNER JOIN with sales, customers, and products).

SELECT
	*
FROM 
	Sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
JOIN
	products p
ON
	s.product_id = p.product_id
WHERE
	p.category = 'Accessories'
	AND
	s.order_status = 'Completed';

-- Show the order details of customers who have paid for their orders, 
-- excluding those who have cancelled their orders 
-- (use INNER JOIN between sales and payments and apply WHERE for order_status).

SELECT
	*
FROM
	sales s
JOIN
	payments p 
ON
	s.order_id = p.order_id
WHERE
	s.order_status <> 'Cancelled';


-- Retrieve products ordered by customers who are in the 'Gujarat' state and 
-- whose total order price is greater than 15,000 (use INNER JOIN between sales, customers, and products).

SELECT
	*  -- We can also select the required fields by calling the specific table alias name and column name like s.order_id, c.customer_name
FROM
	sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
JOIN
	products p
ON
	s.product_id = p.product_id
WHERE
	c.state = 'Gujarat'
	AND
	s.price_per_unit * s.quantity > 15000;


-- Joins + Group BY + Having
-- ●	Find the total quantity of each product ordered by customers from 'Delhi' and only include products with a quantity greater than 5 (use INNER JOIN with sales, customers, and products and group by product).
-- ●	Get the average payment amount per customer who has placed more than 3 orders (use INNER JOIN between paymentsand sales, group by customer, and apply a HAVING clause).
-- ●	Retrieve the total sales for each product category and only include categories where the total sales exceed 100,000 (use INNER JOIN between sales and products, group by category).
-- ●	Show the number of customers in each state who have made purchases with a total spend greater than 50,000 (use INNER JOIN between sales and customers).
-- ●	List the total sales by brand for products that have been ordered more than 10 times (use INNER JOIN between salesand products, group by brand).

-- Find the total quantity of each product ordered by customers from 'Delhi' and 
-- only include products with a quantity greater than 5 (use INNER JOIN with sales, customers, and products and group by product).

SELECT 
	s.product_id,
	p.product_name,
	SUM(s.quantity) as total_quantity
FROM 
	sales s
JOIN
	customers c
ON
	c.customer_id = s.customer_id
JOIN
	products p
ON 
	s.product_id = p.product_id
--WHERE 	c.state = 'Delhi'     -- if using this where clause, need to remove the AND clause in having and remove c.state in GROUP BY
GROUP BY
	s.product_id, p.product_name, c.state
HAVING
	SUM(s.quantity) > 5
	AND
	c.state = 'Delhi';

-- Get the average payment amount per customer who has placed more than 3 orders
-- (use INNER JOIN between paymentsand sales, group by customer, and apply a HAVING clause).

SELECT
	s.customer_id,
	c.customer_name,
	ROUND(AVG(s.price_per_unit * s.quantity)::NUMERIC,2) as average_payment_amt
FROM
	sales s
JOIN
	payments p
ON
	p.order_id = s.order_id
JOIN
	customers c
ON
	c.customer_id = s.customer_id
GROUP BY
	1,2
HAVING
	COUNT(p.payment_id) > 3
ORDER BY 3;


-- Retrieve the total sales for each product category and only include categories
-- where the total sales exceed 100,000 (use INNER JOIN between sales and products, group by category).

SELECT 
	p.product_id,
	p.product_name,
	p.category,
	SUM(s.price_per_unit * s.quantity) as total_sales
FROM 
	sales s 
JOIN
	products p
ON
	s.product_id = p.product_id
GROUP BY
	1,2,3
HAVING
	SUM(s.price_per_unit * s.quantity) > 100000
ORDER BY 4

-- Show the number of customers in each state who have made purchases with a 
-- total spend greater than 50,000 (use INNER JOIN between sales and customers).


SELECT
	c.state,
	COUNT(DISTINCT c.customer_id) as total_customers,
	SUM(s.price_per_unit * s.quantity) as total_spend
FROM
	sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
GROUP BY 1
HAVING
	SUM(s.price_per_unit * s.quantity) > 50000
ORDER BY 3 DESC;

-- List the total sales by brand for products that have been ordered more than 10 times 
-- (use INNER JOIN between sales and products, group by brand).

SELECT
	p.brand,
	p.product_id,
	p.product_name,
	COUNT(s.order_id) as total_ordered_count
FROM 
	sales s
JOIN
	products p
ON
	s.product_id = p.product_id
GROUP BY
	1,2,3
HAVING
	COUNT(s.order_id) > 10
ORDER BY 1, 2 DESC;


-- Joins + WHERE + Group BY + HAVING + ORDER BY
-- ●	Retrieve the total sales per customer in 'Delhi' where the order status is 'Completed', only include those with total sales greater than 50,000, and order the results by total sales (use INNER JOIN between sales and customers).
-- ●	Show the total quantity sold per product in the 'Accessories' category where the total quantity sold is greater than 50 and order the results by product name (use INNER JOIN between sales and products).
-- ●	Find the total number of orders for customers from 'Maharashtra' who have spent more than 1,00,000, and order the results by the total amount spent (use INNER JOIN between sales and customers).
-- ●	Get the number of orders per product and filter to include only products that have been ordered more than 10 times, then order the results by the highest number of orders (use INNER JOIN between sales and products).
-- ●	Retrieve the number of payments made per customer where the payment status is 'Payment Successed' and group by customer, ordering by payment count (use INNER JOIN between payments and customers).

-- Retrieve the total sales per customer in 'Delhi' where the order status is 'Completed',
-- only include those with total sales greater than 50,000,
-- and order the results by total sales (use INNER JOIN between sales and customers).


SELECT
	s.customer_id,
	c.customer_name,
	SUM(s.price_per_unit * s.quantity) as total_sales
FROM
	sales s
JOIN
	customers c
ON s.customer_id = c.customer_id
WHERE
	c.state = 'Delhi'
	AND
	s.order_status = 'Completed'
GROUP BY 
	s.customer_id, c.customer_name
HAVING
	SUM(s.price_per_unit * s.quantity) > 50000
ORDER BY 3;

-- Show the total quantity sold per product in the 'Accessories' category where the total quantity sold is greater than 50
-- and order the results by product name (use INNER JOIN between sales and products).

SELECT
	s.product_id,
	p.product_name,
	SUM(s.quantity) as total_quantity
FROM
	Sales s 
JOIN
	products p
ON s.product_id = p.product_id
WHERE
	p.category = 'Accessories'
GROUP BY 
	1,2
HAVING
	SUM(s.quantity) > 50
ORDER BY 
	2;

-- Find the total number of orders for customers from 'Maharashtra' who have spent more than 1,00,000, 
-- and order the results by the total amount spent (use INNER JOIN between sales and customers).

SELECT	
	s.customer_id,
	c.customer_name,
	COUNT(s.order_id) as total_orders,
	SUM(s.price_per_unit * s.quantity) as total_spent
FROM
	sales s
JOIN
	customers c
ON s.customer_id = c.customer_id
WHERE
	c.state = 'Maharashtra'
GROUP BY
	1,2
HAVING
	SUM(s.price_per_unit * s.quantity) > 100000
ORDER BY 4;

-- Get the number of orders per product and filter to include only products that have been ordered more than 10 times,
-- then order the results by the highest number of orders (use INNER JOIN between sales and products).

SELECT 
	s.product_id,
	p.product_name,
	COUNT(s.order_id) as total_orders_count
FROM 
	sales s
JOIN 
	products p
ON s.product_id = p.product_id
GROUP BY
	1,2
HAVING
	COUNT(s.order_id) > 10
ORDER BY 3 DESC;

-- Retrieve the number of payments made per customer where the payment status is 'Payment Successed' 
-- and group by customer, ordering by payment count (use INNER JOIN between payments and customers).

SELECT 
	s.customer_id,
	c.customer_name,
	COUNT(p.payment_id) as total_successful_payments
FROM
	sales s
JOIN
	payments p
ON p.order_id = s.order_id
JOIN
	customers c
ON c.customer_id = s.customer_id
WHERE
	p.payment_status = 'Payment Successed'
GROUP BY
	1,2
ORDER BY 3 DESC;

-- DATE FUNCTIONS
-- ●	List all orders that were placed within the year 2023 (use order_date with the EXTRACT function).
-- ●	Retrieve customers who have made purchases in the month of January (use order_date and TO_CHAR to extract the month).
-- ●	Calculate the number of days between the payment_date and order_date for each order (use the AGE function).
-- ●	Find the total sales for each year (use EXTRACT with order_date to group by year).
-- ●	Show all orders where the shipping date is after the payment date (use date comparison).

--	List all orders that were placed within the year 2023 (use order_date with the EXTRACT function).

SELECT 
	*
FROM sales
WHERE
	EXTRACT(YEAR from order_date) = 2023;

-- Retrieve customers who have made purchases in the month of January (use order_date and TO_CHAR to extract the month).

SELECT 
	*,
	TO_CHAR(order_date, 'Month') as months
FROM sales
WHERE
	TRIM(TO_CHAR(order_date, 'Month')) = 'January'

-- Calculate the number of days between the payment_date and order_date for each order (use the AGE function).

SELECT 
	*,
	AGE(p.payment_date, s.order_date) as total_days
FROM
	sales s
JOIN
	payments p
ON
	s.order_id = p.order_id
ORDER BY total_days DESC;

-- Find the total sales for each year (use EXTRACT with order_date to group by year).

SELECT
	EXTRACT(YEAR FROM order_date) as order_year,
	SUM(price_per_unit * quantity) as total_sales
FROM 
	sales
GROUP BY 1
ORDER BY 1;

--	Show all orders where the shipping date is after the payment date (use date comparison).

SELECT 
	*
FROM
	sales s
JOIN
	payments p
ON s.order_id = p.order_id
JOIN
	shippings sp
ON s.order_id = sp.order_id
WHERE
	sp.shipping_date > p.payment_date



