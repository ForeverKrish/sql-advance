-- Databricks notebook source
-- MAGIC %md
-- MAGIC # NUMERIC Function

-- COMMAND ----------

use practice_db;

-- COMMAND ----------

select * from orders o join products p using (product_id)

-- COMMAND ----------

use practice_db;

with spent as(
select 
    o.customer_id,
    floor(sum(o.units*p.unit_price)/10)*10 as customer_bin
  from orders o join products p using (product_id)
  group by o.customer_id
)

select customer_bin as customer_spent_range,
  count(customer_id) as customer_count
  from spent
  group by customer_spent_range
  order by customer_spent_range
  
