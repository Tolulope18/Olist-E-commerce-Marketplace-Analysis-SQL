-- QUESTION 3: Geographic Performance
-- Business question: Which Brazilian states contribute the most customers and GMV,
-- and how does GMV per customer vary?
-- Metrics: State GMV, distinct customers, and GMV per customer.

DROP TEMPORARY TABLE IF EXISTS TABLE4;

CREATE TEMPORARY TABLE TABLE4 AS 
SELECT t1.customer_id, t1.customer_unique_id, t1.customer_state, t2.order_id,
t3.price
FROM olist_customers_dataset t1
JOIN olist_orders_dataset t2
	ON t1.customer_id = t2.customer_id
JOIN olist_order_items_dataset t3
	ON t2.order_id = t3.order_id
WHERE order_status != 'unavailable'
	AND order_status != 'canceled';

SELECT customer_state, SUM(price) AS state_gmv, COUNT(DISTINCT customer_unique_id) AS customers_per_state,
(SUM(price)/ COUNT(DISTINCT customer_unique_id)) AS gmv_per_customer
FROM TABLE4
GROUP BY customer_state
ORDER BY state_gmv DESC;

-- QUESTION 4: Seller and Product Category Performance
-- Business question: Which sellers and product categories contribute most to GMV
-- and order activity?
-- Metrics: Seller GMV, seller order count, share of GMV, cumulative GMV share,
-- category GMV, and category order count.

DROP TEMPORARY TABLE IF EXISTS sellers_prods_table;

CREATE TEMPORARY TABLE sellers_prods_table AS
SELECT t3.order_id, t3.seller_id, t3.price, t5.product_category_name
FROM olist_order_items_dataset t3
JOIN olist_orders_dataset t4
	ON t3.order_id = t4.order_id
JOIN olist_products_dataset t5
	ON t3.product_id = t5.product_id
WHERE order_status != 'unavailable'
	AND order_status != 'canceled';

WITH sellers_gmv_table AS (
SELECT seller_id, COUNT(DISTINCT order_id) sellers_orders_count, SUM(price) sellers_gmv
FROM sellers_prods_table
GROUP BY seller_id
ORDER BY sellers_gmv DESC),

share_gmv_table AS (
SELECT *, (sellers_gmv/SUM(sellers_gmv) OVER()) * 100 share_of_gmv,
DENSE_RANK() OVER(ORDER BY sellers_gmv DESC) gmv_rank
FROM sellers_gmv_table)

SELECT *,
SUM(share_of_gmv) OVER(ORDER BY sellers_gmv DESC) cummulative_gmv_share
FROM share_gmv_table;

-- Product category performance
-- Compares categories by GMV and distinct order count.

SELECT product_category_name, COUNT(DISTINCT order_id) prods_cat_orders_count, SUM(price) prods_cats_gmv
FROM sellers_prods_table
GROUP BY product_category_name
ORDER BY prods_cats_gmv DESC;
