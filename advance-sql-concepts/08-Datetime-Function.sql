-- Databricks notebook source
-- MAGIC %md
-- MAGIC # DATETIME Function

-- COMMAND ----------

use practice_db;
select * from orders;

-- COMMAND ----------

with order_cte as (
  select 
    order_id,
    units,
    order_id,
    product_id,
    order_date,
    dateadd(order_date, 2) as ship_date, --DATEADD(order_date, INTERVAL 2 day) as ship_date, //mysql
    year(order_date) as order_year,
    quarter(order_date) as order_quater
  from orders
)
select 
order_id,
product_id,
units,
order_year,
order_quater,
order_date,
ship_date
from order_cte where order_year = '2024' AND order_quater = '2'
order by order_id,product_id