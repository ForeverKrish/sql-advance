-- Databricks notebook source
use practice_db;
select * from products;

-- COMMAND ----------

select * from orders;

-- COMMAND ----------

select 
order_id,
product_id,
units,
dense_rank() OVER(partition by order_id order by units desc) as rnk
from orders 
order by order_id,rnk

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### FIRST_VALUE(), LAST_VALUE(),NTH_VALUE()

-- COMMAND ----------

use practice_db;
with popular_order (select 
order_id,
product_id,
units,
dense_rank() over(partition by order_id order by units desc) as rnk
from orders ) 
select * from popular_order
where rnk =2
order by order_id,rnk

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Another approach using NTH_VALUE

-- COMMAND ----------

select order_id,second_product,units from 
(
  select 
    order_id,
    product_id,
    nth_value(product_id,2) over(partition by order_id order by units desc) as second_product,
    units
  from orders
  order by order_id,second_product
) 
where product_id=second_product -- imp to remove duplicate

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### LEAD() LAG()

-- COMMAND ----------

use practice_db;
with current_orders AS(
  select 
    customer_id,order_id,min(transaction_id) as trans_id,sum(units) as current_units
  from orders
  group by customer_id,order_id
),
prev_orders AS(
  select 
    *, 
    lag(current_units) over (partition by customer_id order by trans_id) as previous_units
  from current_orders
)
select 
  customer_id,order_id,trans_id,current_units,previous_units,
  current_units - previous_units as diff_units
from prev_orders
order by customer_id,order_id,trans_id desc;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Statistical Functions

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### NTILE()

-- COMMAND ----------

use practice_db;
with customer_purchase AS (
  select 
    o.customer_id,
    sum(o.units*p.unit_price) as total_spent
  from orders o
  join products p using (product_id)
  group by customer_id
),
customer_purchase_percentile AS (
  select
  *,
  NTILE(100) OVER(partition by customer_id order by total_spent desc) as customer_spent_percentile
  from customer_purchase 
)
select customer_id,total_spent from customer_purchase_percentile
where customer_spent_percentile = 1
order by total_spent desc