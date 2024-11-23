-- Flipkart Database Setup

DROP TABLE IF EXISTS payments, shippings, sales, products, customers;

CREATE TABLE customers
(
	customer_id	INT PRIMARY KEY,
	customer_name	VARCHAR(35),
	state VARCHAR(25)
);

CREATE TABLE products
(
	product_id INT PRIMARY KEY,	
	product_name	VARCHAR(45),
	price	FLOAT,
	cogs	FLOAT,
	category	VARCHAR(25),
	brand VARCHAR(25)
);

CREATE TABLE sales
(
order_id	INT PRIMARY KEY,
order_date date,	
customer_id	INT REFERENCES customers(customer_id),
order_status VARCHAR(25),	
product_id	INT REFERENCES products(product_id),
quantity	INT, 
price_per_unit FLOAT
-- ,CONSTRAINT customer_id_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
-- CONSTRAINT product_id_prod FOREIGN KEY (product_id) REFERENCES products(product_id)
);



CREATE TABLE payments
(
payment_id	INT,
order_id	INT REFERENCES sales(order_id),
payment_date	date,
payment_status VARCHAR(55)
);

CREATE TABLE shippings
(
shipping_id INT,	
order_id	INT REFERENCES sales(order_id),
shipping_date	DATE,
return_date	 DATE,
shipping_providers VARCHAR(55),	
delivery_status VARCHAR(55)	
);

SELECT 'Flipkart Database created successfull!';

