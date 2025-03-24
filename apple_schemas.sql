-- Data Analysis Project
-- APPLE - A leading tech company known for innovative electronics like iPhone, Mac, and iOS.

CREATE DATABASE apple_db;

-- 	Drop existing tables, if available
	DROP TABLE IF EXISTS category;
	DROP TABLE IF EXISTS stores;
	DROP TABLE IF EXISTS products;
	DROP TABLE IF EXISTS sales;
	DROP TABLE IF EXISTS warranty;
	
-- Create category table
	DROP TABLE IF EXISTS category;
	CREATE TABLE category
	(
	category_id VARCHAR(10) PRIMARY KEY,
	category_name VARCHAR(20)
	);

-- Create stores table
	DROP TABLE IF EXISTS stores;
	CREATE TABLE stores
	(
	store_id VARCHAR(5) PRIMARY KEY,
	store_name	VARCHAR(30),
	city	VARCHAR(25),
	country VARCHAR(25)
	);

-- Create products table
	DROP TABLE IF EXISTS products;
	CREATE TABLE products
	(
	product_id	VARCHAR(10) PRIMARY KEY,
	product_name	VARCHAR(35),
	category_id	VARCHAR(10),
	launch_date	date,
	price FLOAT,
	CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
	);

-- Create sales table
	DROP TABLE IF EXISTS sales;
	CREATE TABLE sales
	(
	sale_id	VARCHAR(15) PRIMARY KEY,
	sale_date	DATE,
	store_id	VARCHAR(10), -- this fk
	product_id	VARCHAR(10), -- this fk
	quantity INT,
	CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
	CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
	);
	
-- Create warranty table
	DROP TABLE IF EXISTS warranty;
	CREATE TABLE warranty
	(
	claim_id VARCHAR(10) PRIMARY KEY,	
	claim_date	date,
	sale_id	VARCHAR(15),
	repair_status VARCHAR(15),
	CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
	);

-- END of Schemas

	SELECT * FROM category;
	SELECT * FROM stores;
	SELECT * FROM products;
	SELECT * FROM sales;
	SELECT * FROM warranty;

-- Import data into tables in the below order
-- - category
-- - stores
-- - products
-- - sales
-- - warranty