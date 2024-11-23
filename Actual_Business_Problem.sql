-- 1.	Retrieve all products along with their total sales revenue from completed orders.
-- 2.	List all customers and the products they have purchased, showing only those who have ordered more than two products.
-- 3.	Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000.
-- 4.	Retrieve the list of all orders that have not yet been shipped.
-- 5.	Find the average order value per customer for orders with a quantity of more than 5.
-- 6.	Get the top 5 customers by total spending on 'Accessories'.
-- 7.	Retrieve a list of customers who have not made any payment for their orders.
-- 8.	Find the most popular product based on total quantity sold in 2023.
-- 9.	List all orders that were cancelled and the reason for cancellation (if available).
-- 10.	Retrieve the total quantity of products sold by category in 2023.
-- 11.	Get the count of returned orders by shipping provider in 2023.
-- 12.	Show the total revenue generated per month for the year 2023.
-- 13.	Find the customers who have made the most purchases in a single month.
-- 14.	Retrieve the number of orders made per product category in 2023 and order by total quantity sold.
-- 15.	List the products that have never been ordered (use LEFT JOIN between products and sales).


-- 1.	Retrieve all products along with their total sales revenue from completed orders.

SELECT
	s.product_id,
	p.product_name,
	s.price_per_unit,
	SUM(s.quantity) AS total_quantity_sold,
	SUM(s.price_per_unit * s.quantity) AS total_sales_revenue
FROM 
	sales s 
JOIN
	products p
ON
	s.product_id = p.product_id
WHERE
	s.order_status = 'Completed'
GROUP BY
	1,2,3
ORDER BY 4 DESC;

-- 2.	List all customers and the products they have purchased, showing only those who have ordered more than two products.

SELECT
	s.customer_id,
	c.customer_name,
	s.product_id,
	p.product_name,
	COUNT(*) as total_orders   -- to fetch the count of order for the same product
FROM
	sales s
JOIN
	customers c
ON	s.customer_id = c.customer_id
JOIN
	products p 
ON	p.product_id = s.product_id
WHERE
	s.order_status IN ('Completed','Inprogress') -- Excluded the order which are Returned or Cancelled OR -- we can fetch only for Completed by eXcluding InProgress
GROUP BY
	1,2,3,4
HAVING
 	COUNT(s.order_id) > 2
ORDER BY
	1,2

-- 3.	Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000.

SELECT
	s.customer_id,
	c.customer_name,
	p.product_id,
	p.product_name,
	SUM(s.price_per_unit * s.quantity) as total_amount_spent
FROM
	sales s
JOIN
	customers c
ON
	s.customer_id = c.customer_id
JOIN
	products p 
ON
	p.product_id = s.product_id
WHERE
	c.state = 'Gujarat'
	AND
	s.price_per_unit > 10000
GROUP BY
	1,2,3,4
ORDER BY 1, 5 DESC;

-- 4.	Retrieve the list of all orders that have not yet been shipped.


SELECT 
	*
FROM 
	sales s
JOIN
	payments p
ON
	p.order_id = s.order_id
LEFT JOIN	
	shippings sp
ON
	s.order_id = sp.order_id
WHERE
	sp.shipping_id IS NULL;

-- OR --

SELECT * 
FROM 
	sales
WHERE
	order_id NOT IN (
						SELECT DISTINCT order_id from shippings
					 );
-- OR --

SELECT
	*
FROM (
		SELECT * 
		FROM 
			sales
		WHERE
			order_id NOT IN (
								SELECT DISTINCT order_id from shippings)
	) as nsp
JOIN
	payments p
ON
	nsp.order_id = p.order_id;


-- 5.	Find the average order value per customer for orders with a quantity of more than 5.

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

-- 6.	Get the top 5 customers by total spending on 'Accessories'.

SELECT 
	c.customer_id,
	c.customer_name,
	p.category,
	SUM(s.price_per_unit * s.quantity) as total_spends
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
	p.category = 'Accessories'
GROUP BY
	1,2,3
ORDER BY 4 DESC
LIMIT 5;

-- 7.	Retrieve a list of customers who have not made any payment for their orders.

SELECT
	*
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

-- 8.	Find the most popular product based on total quantity sold in 2023.

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

-- 9.	List all orders that were cancelled and the reason for cancellation (if available).

SELECT
	s.*,
	p.payment_status as cancellation_reason
FROM
	sales s
JOIN
	payments p
ON
	s.order_id = p.order_id
WHERE
	s.order_status = 'Cancelled'

-- 10.	Retrieve the total quantity of products sold by category in 2023.

SELECT
	EXTRACT(YEAR FROM order_date) AS year_sold,
	p.category,
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
ORDER BY 3 DESC;

-- 11.	Get the count of returned orders by shipping provider in 2023.

SELECT 
	shipping_providers,
	COUNT(order_id) as total_orders_returned_in_2023
from shippings
WHERE
	delivery_status = 'Returned'
	AND
	EXTRACT(YEAR FROM shipping_date) = 2023
GROUP BY
	1
ORDER BY 2 DESC;

-- 12.	Show the total revenue generated per month for the year 2023.


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

-- 13.	Find the customers who have made the most purchases in a single month.

-- 14.	Retrieve the number of orders made per product category in 2023 and order by total quantity sold.

SELECT
	p.category,
	COUNT(s.order_id) AS total_orders_placed,
	SUM(s.quantity) AS total_quantity
FROM
	sales s
JOIN
	products p 
ON 
	s.product_id = p.product_id
WHERE	
	EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY 1
ORDER BY 3 DESC

-- 15.	List the products that have never been ordered (use LEFT JOIN between products and sales).

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
	s.product_id IS NULL;
	-- p.product_id NOT IN (
	-- 						SELECT DISTINCT product_id from sales
	-- 					) 




