-- QUESTION 1: Marketplace Performance Over Time
-- Metrics: Monthly GMV, order volume, and average order value

DROP TEMPORARY TABLE IF EXISTS TABLE1;

WITH TABLE1 AS (
SELECT T1.order_id, T1.order_item_id, T1.price,
DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year__month
FROM olist_order_items_dataset T1
JOIN olist_orders_dataset T2
	ON T1.order_id = T2.order_id
WHERE order_status != 'unavailable'
	AND order_status != 'canceled') 

SELECT year__month, SUM(price) AS monthly_gmv, COUNT(DISTINCT order_id) AS monthly_total_order, 
(SUM(price)/COUNT(DISTINCT order_id)) AS average_order_value
FROM TABLE1
GROUP BY(year__month)
ORDER BY(year__month);

-- QUESTION 2: Customer Acquisition and Repeat Purchasing
-- Metrics: Monthly new customers, returning customers, and returning-customer percentage

DROP TEMPORARY TABLE IF EXISTS TABLE2;

CREATE TEMPORARY TABLE TABLE2 AS 
SELECT customers.customer_unique_id, DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year__month
FROM olist_customers_dataset AS customers
JOIN olist_orders_dataset AS orders
	ON customers.customer_id = orders.customer_id
WHERE order_status != 'unavailable'
	AND order_status != 'canceled'
GROUP BY customer_unique_id, year__month;

DROP TEMPORARY TABLE IF EXISTS first_orders;

CREATE TEMPORARY TABLE first_orders AS 
SELECT customer_unique_id, MIN(year__month) AS customer_first_order
FROM TABLE2
GROUP BY customer_unique_id;

DROP TEMPORARY TABLE IF EXISTS TABLE3;

CREATE TEMPORARY TABLE TABLE3 AS
SELECT TABLE2.*, first_orders.customer_first_order
FROM TABLE2
JOIN first_orders
	ON TABLE2.customer_unique_id = first_orders.customer_unique_id;


WITH customer_type_table AS (
SELECT *, 
CASE
WHEN year__month = customer_first_order THEN 'new customer'
WHEN year__month > customer_first_order THEN 'returning customer'
END AS customer_type
FROM TABLE3
)

SELECT year__month,
    SUM(customer_type = 'new customer') AS new_customers,
    SUM(customer_type = 'returning customer') AS returning_customers,
    ROUND(
        SUM(customer_type = 'returning customer') / COUNT(*) * 100, 2
    ) AS returning_customer_pct
FROM customer_type_table
GROUP BY year__month
ORDER BY year__month;