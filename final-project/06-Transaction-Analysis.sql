-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Transaction Analysis

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. Print the transaction table

-- COMMAND ----------

use final_project;
select * from trans;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Identify customers who have made at least two consecutive purchases within 7 days of each other

-- COMMAND ----------

with trasaction_cte AS (
  select
    customer_id,
    transaction_id,
    purchase_date,
    amount,
    LAG(purchase_date) OVER(partition by customer_id order by purchase_date) as prev_purchase_date,
    date_diff(day,LAG(purchase_date) OVER(partition by customer_id order by purchase_date),purchase_date) as consecutive_purchase_date_diff
  from 
  final_project.trans 
  order by customer_id , transaction_id 
)
select 
  distinct customer_id
from 
  trasaction_cte where consecutive_purchase_date_diff <= 7

