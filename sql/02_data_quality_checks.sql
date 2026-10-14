-- Check missing or blank values in the customers dataset
SELECT *
FROM olist_customers_dataset
WHERE (customer_id IS NULL OR customer_id = ' ')
	OR (customer_unique_id IS NULL OR customer_unique_id = ' ')
    OR (customer_zip_code_prefix IS NULL OR customer_zip_code_prefix = ' ')
    OR (customer_city IS NULL OR customer_city = ' ')
    OR (customer_state IS NULL OR customer_state = ' ');

-- Check missing or blank values in the order items dataset
SELECT *
FROM olist_order_items_dataset
WHERE (order_id IS NULL OR order_id = ' ')
	OR (order_item_id IS NULL OR order_item_id = ' ')
    OR (product_id IS NULL OR product_id = ' ')
    OR (seller_id IS NULL OR seller_id = ' ')
    OR (shipping_limit_date IS NULL)
    OR (price IS NULL OR price = ' ')
    OR (freight_value IS NULL OR freight_value = ' ');


-- Check missing or blank values in the order payments dataset
SELECT *
FROM olist_order_payments_dataset
WHERE (order_id IS NULL OR order_id = '')
	OR (payment_sequential IS NULL OR payment_sequential = '')
	OR (payment_type IS NULL OR payment_type = '')
	OR (payment_installments IS NULL OR payment_installments = '')
	OR (payment_value IS NULL OR payment_value = '');
        
-- Check missing or blank values in the order reviews dataset
SELECT *
FROM olist_order_reviews_dataset
WHERE (review_id IS NULL OR review_id = '')
	OR (order_id IS NULL OR order_id = '')
	OR (review_score IS NULL OR review_score = '')
	OR (review_comment_title IS NULL OR review_comment_title = '')
	OR (review_comment_message IS NULL OR review_comment_message = '')
	OR (review_creation_date IS NULL)
	OR (review_answer_timestamp IS NULL);

-- Check missing or blank values in the orders dataset
SELECT *
FROM olist_orders_dataset
WHERE (order_id IS NULL OR order_id = '')
	 OR (customer_id IS NULL OR customer_id = '')
     OR (order_status IS NULL OR order_status = '');

-- Check missing or blank values in the products dataset
SELECT * 
FROM olist_products_dataset
WHERE (product_id IS NULL OR product_id = '')
	OR (product_category_name IS NULL OR product_category_name = '')
    OR (product_name_lenght IS NULL OR product_name_lenght = '')
    OR (product_description_lenght IS NULL OR product_description_lenght = '')
    OR (product_photos_qty IS NULL OR product_photos_qty = '')
    OR (product_weight_g IS NULL OR product_weight_g = '')
    OR (product_length_cm IS NULL OR product_length_cm = '')
    OR (product_width_cm IS NULL OR product_width_cm = '');
    
-- Check missing or blank values in the sellers dataset
SELECT *
FROM olist_sellers_dataset
WHERE (seller_id IS NULL OR seller_id = '')
	OR (seller_zip_code_prefix IS NULL OR seller_zip_code_prefix = '')
    OR (seller_city IS NULL OR seller_city = '')
    OR (seller_state IS NULL OR seller_state = '');
     