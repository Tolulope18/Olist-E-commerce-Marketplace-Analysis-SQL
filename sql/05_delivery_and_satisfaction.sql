-- QUESTION 5: Delivery Performance and Customer Satisfaction
-- Business question: How often are orders late, how does late delivery vary
-- over time, and how are delivery delays associated with low review scores?

-- PART 1: Overall Delivery Performance
-- Classifies eligible delivered orders as on time or late by comparing
-- actual and estimated delivery dates.
-- Metrics: Number and percentage of eligible orders delivered on time or late.

DROP TEMPORARY TABLE IF EXISTS TABLE5;

CREATE TEMPORARY TABLE TABLE5 AS
SELECT order_id, order_purchase_timestamp,
DATE(order_estimated_delivery_date) estimated_delivery_date,
DATE(order_delivered_customer_date) actual_delivery_date,
CASE
WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date) THEN 'on time'
WHEN DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date) THEN 'late'
END delivery_status
FROM olist_orders_dataset 
WHERE order_status = 'delivered'
    AND (order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL);
    
WITH delivery_status_count_table AS (
SELECT delivery_status, COUNT(delivery_status) delivery_status_count
FROM TABLE5
GROUP BY delivery_status)

SELECT *, (delivery_status_count/SUM(delivery_status_count) OVER()) * 100 pct_delivery__status
FROM delivery_status_count_table;

-- PART 2: Monthly Late-Delivery Trend
-- Measures the percentage of eligible delivered orders that arrived late,
-- grouped by the month the order was placed.

WITH monthly_delivery_status AS (
SELECT 
DATE_FORMAT(order_purchase_timestamp, '%Y-%m') year__month, delivery_status,
COUNT(delivery_status) delivery_status_count
FROM TABLE5
GROUP BY year__month, delivery_status
ORDER BY year__month, delivery_status)

SELECT *, (delivery_status_count/monthly_order) * 100 AS mothly_late_delivery_pct
FROM (SELECT *, SUM(delivery_status_count) OVER(PARTITION BY year__month) monthly_order
FROM monthly_delivery_status) monthly_order_table
WHERE delivery_status = 'late';

-- PART 3: Delivery Status and Customer Satisfaction
-- Compares the percentage of low review scores (1 or 2) for on-time
-- and late deliveries.
-- Note: This analysis counts review records, not unique orders.

SELECT delivery_status,
COUNT(review_score) total_reviews,
SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END) low_reviews,
SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END) /
COUNT(review_score) * 100 low_review_pct
FROM TABLE5 t6
JOIN olist_order_reviews_dataset t7
	ON t6.order_id = t7.order_id
WHERE delivery_status IS NOT NULL
    AND review_score IS NOT NULL
GROUP BY delivery_status;