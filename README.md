# Comprehensive Data Analysis using SQL
# Apple - A leading tech company known for innovative electronics like iPhone, Mac, and iOS.

![AMAZON](https://github.com/Akshay-Vallam/Data-Analysis-Apple/blob/main/apple_image.png)
*Image Credit: apple.com*

## Overview

This project demonstrates my problem-solving skills through the analysis of 5 comprehensive datasets having more than 1 Million records for the company Apple. This project involves usage of PostgreSQL. It helped me to understand the following business insights:

 - Customer Behaviour, Segmentation and Insights
 - Sales Trends and Revenue Analysis
 - Store Management
 - Warranty Claims Analysis
 - Product Performance

This project has helped me develop the following skills:

 - Demonstrating the ability to perform complex SQL joins and aggregate data meaningfully.
 - Using advanced window functions for running totals, growth analysis, and time-based queries.
 - Analyzing data across different time frames to gain insights into product performance.
 - Applying SQL functions to determine relationships between variables, such as product price and warranty claims.
 - Answering business-related questions that reflect real-world scenarios faced by data analysts.

## Datasets

- **Period Covered**: The data spans across multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Data from various countries around the world.

## Project Structure

- **Database Setup:** Creation of the `apple_db` database and the required tables.
- **Data Import:** Inserting sample data into the tables.
- **Data Cleaning:** Handling null values and ensuring data integrity.
- **Business Problems:** Solving 21 specific business problems using SQL queries.

![ERD](https://github.com/Akshay-Vallam/Data-Analysis-Apple/blob/main/apple_schemas_erd.png)

## Database Setup
```sql
CREATE DATABASE amazon_db;
```
### 1. Dropping Existing Tables
```sql
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS warranty;
```
### 2. Creating Tables
```sql
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
```
## Data Import

Import data into tables in the below order
- category
- stores
- products
- sales
- warranty

## Data Cleaning

Prior to analysis, I've ensured that the data was clean and free from null values where necessary.

```sql
SELECT * FROM category;
SELECT * FROM stores;
SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM warranty;

-- Handling Null Values

SELECT COUNT(*) FROM category
    WHERE
    category_name IS NULL;

SELECT COUNT(*) FROM stores
    WHERE
    store_name IS NULL
    OR
    city IS NULL
    OR
    country IS NULL;

SELECT COUNT(*) FROM products
    WHERE
    product_name IS NULL
    OR
    category_id IS NULL
    OR
    launch_date IS NULL
    OR
    price IS NULL;

SELECT COUNT(*) FROM sales
    WHERE
    sale_date IS NULL
    OR
    store_id IS NULL
    OR
    product_id IS NULL
    OR
    quantity IS NULL;

SELECT COUNT(*) FROM warranty
    WHERE
    claim_date IS NULL
    OR
    sale_id IS NULL
    OR
    repair_status IS NULL;
```
## Business Problems

### Tables overview
```sql
SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM warranty;
```

### 1. Country-Wise Stores

#### Question: 
#### QFind the number of stores in each country.
	
#### Solution:
```sql
/* Calculate - number of stores
Group - by country	*/

SELECT 
    country,
    COUNT(store_id) as total_stores
FROM stores
GROUP BY 1
ORDER BY 2 DESC;
```

### 2. Units per Store
#### Question: 
#### Calculate the total number of units sold by each store.
	
#### Solution:
```sql
/* join - stores, sales tables
Calculate - sum of quantity
Group - by store id	*/

SELECT
    st.store_id,
    st.store_name,
    SUM(s.quantity) as total_units_sold
FROM stores as st
JOIN sales as s
ON st.store_id = s.store_id
GROUP BY 1, 2
ORDER BY 3 DESC;
```

### 3. Sales per Month
#### Question: 
#### Identify how many sales occurred in December 2023. 

#### Solution:
```sql
/* Calculate - count total sale_id
Where - month is 12-2023 
Use - To-Char */

SELECT 
    COUNT(sale_id) as total_sale
FROM sales
WHERE TO_CHAR(sale_date, 'MM-YYYY') = '12-2023';
```

### 4. Stores with No Warranty Claim
#### Question: 
#### Determine how many stores have never had a warranty claim filed.
	
#### Solution:
```sql
/* Subquery - to find distinct stores
Right Join - sales and warranty
Calculate - count of stores	*/

SELECT COUNT(*) FROM stores
WHERE store_id NOT IN (
                        SELECT 
                            DISTINCT store_id
                        FROM sales as s
                        RIGHT JOIN warranty as w
                        ON s.sale_id = w.sale_id
                        );
```

### 5. Void Warranty Claims
#### Question: 
#### Calculate the percentage of warranty claims marked as "Warranty Void". 
	
#### Solution:
```sql
/* Calculate - Count of claim_id of Warranty void / Total count of claim 
Where - repair_status = Wararnty void*/

SELECT 
    ROUND(
        COUNT(claim_id)
                    /(SELECT COUNT(claim_id) FROM warranty)::numeric*100,
                    2) as warranty_void_percentage
FROM warranty
WHERE repair_status = 'Warranty Void';
```

### 6. Top Selling Stores
#### Question: 
#### Identify which store had the highest total units sold in the last 1 and half year.
	
#### Solution:
```sql
/* Join - sales, stores tables
Where - sale_date >= current date - 1 year 6 Month
Calculate - sum of quantity	*/

SELECT 
    s.store_id,
    st.store_name,
    st.city,
    st.country,
    SUM(s.quantity)
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 Year 6 Month')
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC
LIMIT 1;
```
	
### 7. Unique Products
#### Question: 
#### Count the number of unique products sold in the last 1 and half year.
	
#### Solution:
```sql
/* Calculate - count of distinct product_id
Where - sale_date > = current date - 1 and half year */

SELECT 
    COUNT(DISTINCT product_id)
FROM sales
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 Year 6 Month');
```

### 8. Average Price per Category
#### Question: 
#### Find the average price of products in each category.
	
#### Solution:
```sql
/* Join - products, category tables
Calculate - avg of price */

SELECT
    p.category_id,
    c.category_name,
    ROUND(AVG(p.price)::numeric, 2) as avg_price
FROM products as p
JOIN category as c
ON p.category_id = c.category_id
GROUP BY 1, 2
ORDER BY 3 DESC;
```

### 9. Warranty Claims
#### Question: 
#### How many warranty claims were filed in 2020.
	
#### Solution:
```sql
/* Calculate - count of claim_id
Where - year is 2020 */

SELECT 
    COUNT(claim_id) as warranty_claim
FROM warranty
WHERE EXTRACT (YEAR FROM claim_date) = 2020;
```

### 10. Best-Selling Day
#### Question: 
#### For each store, identify the best-selling day based on highest quantity sold.
	
#### Solution:
```sql
/* CTE - to find day name, sum of qunatity, rank
Use - to_char to extract day from sale_date */

WITH t1 as 
    (
    SELECT 
        store_id,
        TO_CHAR(sale_date, 'Day') as day_name,
        SUM(quantity) as total_unit_sold,
        RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rank
    FROM sales
    GROUP BY 1, 2
    )

SELECT 
    * 
FROM t1
WHERE rank = 1;
```
	
### 11. Least-Selling Products
#### Question: 
#### Identify the least selling product in each country for each year based on total units sold. 
	
#### Solution:
```sql
/* Join - sales, stores, products tables
Calculate - sum of quantity
CTE - to calculate rank
Where - rank is 1 */

WITH t1 as
    (
    SELECT 
        st.country,
        p.product_name,
        SUM(s.quantity) as total_qty_sold,
        RANK() OVER (PARTITION BY st.country ORDER BY SUM(s.quantity)) as rank
    FROM sales as s
    JOIN stores as st
    ON s.store_id = st.store_id
    JOIN products as p
    ON s.product_id = p.product_id
    GROUP BY 1, 2
    )

SELECT 
    *
FROM t1
WHERE rank = 1;
```

### 12. Claims within 6 months of Product Sale
#### Question: 
#### CCalculate how many warranty claims were filed within 180 days of a product sale. 
	
#### Solution:
```sql
/* Left Join - warranty, sales tables
Where - claim_date - sale_date <= 180 */

SELECT
    COUNT(*)
FROM warranty as w
LEFT JOIN sales as s
ON s.sale_id = w.sale_id
WHERE w.claim_date - s.sale_date <= 180;
```

### 13. Claims within 2 years of Product Launch
#### Question: 
#### Determine how many warranty claims were filed for products launched in the last two years.
	
#### Solution:
```sql
/* Right Join - warranty, sales table
Join - to products table
Where - launch_date >= current date - 2 year
Having - claim_id > 0 */

SELECT
    p.product_name,
    COUNT(w.claim_id) as no_claim,
    COUNT(s.sale_id)
FROM warranty as w
RIGHT JOIN sales as s
ON s.sale_id = w.sale_id
JOIN products as p
ON p.product_id = s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '2 Year'
GROUP BY 1
HAVING COUNT(w.claim_id) > 0;
```	
	
### 14. Sales in USA
#### Question: 
#### List the months in the last three years where sales exceeded 5,000 units in the USA.
	
#### Solution:
```sql
/* Join - sales and stores tables
Extract - month using To_char function
Where - country is USA, sale_date is current date - interval 3 years
Having - sum of quantity > 5000 */

SELECT
    TO_CHAR(sale_date, 'MM-YYYY') as month,
    SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
WHERE 
    st.country = 'USA'
    AND
    s.sale_date >= CURRENT_DATE - INTERVAL '3 year'
GROUP BY 1
HAVING SUM(s.quantity) > 5000;
```

### 15. Claims per Category
#### Question: 
#### Identify the product category with the most warranty claims filed in the last two years. 
	
#### Solution:
```sql
/* Join - warranty, sales, products and category tables
Calculate - claim_date >= current_date - interval - 2 year	*/

SELECT
    c.category_name,
    COUNT(w.claim_id) as total_claims
FROM warranty as w
LEFT JOIN sales as s
ON w.sale_id = s.sale_id
JOIN products as p
ON p.product_id = s.product_id
JOIN category as c
ON c.category_id = p.category_id
WHERE w.claim_date >= CURRENT_DATE - INTERVAL '2 year'
GROUP BY 1
ORDER BY 2 DESC;
```
	
### 16. Claims Percentage per Country
#### Question: 
#### Determine the percentage chance of receiving warranty claims after each purchase for each country!
	
#### Solution:
```sql
WITH t1 as 
(
    SELECT
        st.country,
        SUM(s.quantity) as total_unit_sold,
        COUNT(w.claim_id) as total_claim
    FROM sales as s
    JOIN stores as st
    ON s.store_id = st.store_id
    LEFT JOIN
    warranty as w
    ON w.sale_id = s.sale_id
    GROUP BY 1
)

SELECT
    country,
    total_unit_sold,
    total_claim,
    ROUND(COALESCE(total_claim::numeric/total_unit_sold::numeric*100, 0), 2) as risk
FROM t1
ORDER BY 4 DESC;
```

### 17. Growth Ratio
#### Question: 
#### Analyze the year-by-year growth ratio for each store.

#### Solution:
```sql
/* CTE - to calculate sum of quantity * price and extract year from sale_date
Lag - lag by 1 year to calculate last year sale
Compare - it with current year sale
Calculate - growth ratio = (current) year sale - last year sale) / last year sale * 100
Where - last year sale is not null and year is not current year */

WITH yearly_sales AS
(
    SELECT
        s.store_id,
        st.store_name,
        EXTRACT(YEAR FROM sale_date) as year,
        SUM(s.quantity * p.price) as total_sale
    FROM sales as s
    JOIN products as p
    ON s.product_id = p.product_id
    JOIN stores as st
    ON st.store_id = s.store_id
    GROUP BY 1, 2, 3
    ORDER BY 2, 3
),
growth_ratio AS
(
    SELECT
        store_name,
        year,
        LAG(total_sale, 1) OVER(PARTITION BY store_name ORDER BY year) as last_year_sale,
        total_sale as current_year_sale
        FROM yearly_sales
)

SELECT 
    store_name,
    year,
    last_year_sale,
    current_year_sale,
    ROUND((current_year_sale - last_year_sale)::numeric
            /last_year_sale::numeric * 100, 2) as growth_ratio
FROM growth_ratio
WHERE
    last_year_sale IS NOT NULL
    AND
    YEAR <> EXTRACT(YEAR FROM CURRENT_DATE);
```

### 18. Product Price vs Warranty Claims
#### Question: 
#### Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range. 

#### Solution:
```sql
/* Left Join - warranty and sales tables
Join - the above to products table
Case - to segment product based on cost
Calculate - count of claims
Where - claim date is within 5 years */

SELECT
    CASE
        WHEN p.price < 500 THEN 'Less Expensive Product'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid Range Product'
        ELSE 'Expensive Product'
    END as price_segment,
    COUNT(w.claim_id) as total_claim
FROM warranty as w
LEFT JOIN sales as s
ON w.sale_id = s.sale_id
JOIN products as p
ON p.product_id = s.product_id
WHERE claim_date >= CURRENT_DATE - INTERVAL '5 Year'
GROUP BY 1
ORDER BY 2 DESC;
```

### 19. Paid Repairs per Claims
#### Question: 
#### Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
	
#### Solution:
```sql
/* CTE - to calculate count of claim_id where status is Paid Repaired
CTE - to calculate total count of claim_id 
Calculate - percentage of paid repaired to total claims */

WITH paid_repair AS
    (
        SELECT
            s.store_id,
            COUNT(w.claim_id) as paid_repaired
        FROM sales as s
        RIGHT JOIN warranty as w
        ON w.sale_id = s.sale_id
        WHERE w.repair_status = 'Paid Repaired'
        GROUP BY 1
    ),

total_repair AS
(
    SELECT
        s.store_id,
        COUNT(w.claim_id) as total_repaired
    FROM sales as s
    RIGHT JOIN warranty as w
    ON w.sale_id = s.sale_id
    GROUP BY 1
)

SELECT
    tr.store_id,
    st.store_name,
    pr.paid_repaired,
    tr.total_repaired,
    ROUND(pr.paid_repaired::numeric/tr.total_repaired::numeric * 100 ,2) as percentage
FROM paid_repair as pr
JOIN total_repair as tr
ON pr.store_id = tr.store_id
JOIN stores as st
ON tr.store_id = st.store_id
ORDER BY 5 DESC;
```

### 20. Monthy Sales Running Total
#### Question: 
#### Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
	
#### Solution:
```sql
/* CTE - to calculate total revenue and extract month and year
Calculate - sum of total revenue grouped by store_id and ordered by year, month */

WITH monthly_sales AS
(
    SELECT 
        store_id,
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        SUM(p.price * s.quantity) as total_revenue
    FROM sales as s
    JOIN products as p
    ON s.product_id = p.product_id
    GROUP BY 1, 2, 3
    ORDER BY 1, 2, 3
)

SELECT
    *,
    SUM(total_revenue) OVER (PARTITION BY store_id ORDER BY year, month) as running_total
FROM monthly_sales;
```

### 21. Sales Trends
#### Question: 
#### Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
	
#### Solution:
```sql
/* Join - sales and products tables
Categorize - based on launch date to 6, 12, 18 months
Calculate - sum of quantity */

SELECT 
    p.product_name,
    CASE
        WHEN s.sale_date BETWEEN p.launch_date AND p.launch_date + INTERVAL '6 month' THEN '0-6 months'
        WHEN s.sale_date BETWEEN p.launch_date - INTERVAL '6 month' AND p.launch_date + INTERVAL '12 month' THEN '6-12 months'
        WHEN s.sale_date BETWEEN p.launch_date - INTERVAL '12 month' AND p.launch_date + INTERVAL '18 month' THEN '12-18 months'
        ELSE '18 months +'
    END as category,
    SUM(s.quantity) as total_qty_sale
    
FROM sales as s
JOIN products as p
on s.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
```

## Conclusion

This project showcases my proficiency in managing complex SQL queries and offering solutions to practical business challenge to real-world business problems in the context of a product-based company like Apple. The approach here reflects a structured problem-solving methodology, data manipulation skills, and the ability to derive actionable insights from data.

## Notice 

All customer names and data used in this project are computer-generated using AI and random functions. They do not represent real data associated with Amazon or any other entity. This project is solely for learning and educational purposes, and any resemblance to actual persons, businesses, or events is purely coincidental. 

The datasets (CSV files) have not been uploaded to the GitHub repository.

## Source of Inspiration

This project draws ideas, datasets or code structures from the project featured on Youtube channel - Zero Analyst.
