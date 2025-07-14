-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### rolling sum & Cumulative average

-- COMMAND ----------

use practice_db;
select * from orders;

-- COMMAND ----------

select * from products;

-- COMMAND ----------

with sales_cte as (
  select 
    cast(year(o.order_date) as int) as year,
    cast(month(o.order_date) as int) as month,
    sum((o.units*p.unit_price))  as total_monthly_sales
  from orders o
  join products p 
  using (product_id)
  group by year,month
) 
select 
year,
month,
total_monthly_sales,
SUM(total_monthly_sales) OVER(order by year,month rows between unbounded preceding and current row) as cumulative_sum,
ROUND(AVG(total_monthly_sales) OVER(order by year,month rows between 5 preceding and current row),2) as six_month_avg
from sales_cte
order by year,month
