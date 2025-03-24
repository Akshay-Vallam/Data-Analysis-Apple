-- Apple Data Analysis Project - 21 Advaned Business Problems

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