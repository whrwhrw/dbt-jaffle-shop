{{ config(materialized='table') }}

WITH 
customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS number_of_orders,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS most_recent_order_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.number_of_orders,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date
FROM customers
LEFT JOIN customer_orders 
    ON customers.customer_id = customer_orders.customer_id