-- Databricks notebook source
USE practice_db;
select * FROM orders;

-- COMMAND ----------



-- COMMAND ----------

select * from products;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Single CTE

-- COMMAND ----------

with order_details as (
  select 
  * 
  from orders ord 
  inner join products pdt on  
  ord.product_id = pdt.product_id
)
select 
  order_id,customer_id,order_date, sum(units) as total_orders,sum(units*unit_price) as total_order_value
  from order_details 
  group by order_id,customer_id,order_date
  having total_order_value > 200
  order by total_order_value desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Multiple CTEs

-- COMMAND ----------

use practice_db;
select 
  factory,
  product_name,
  count(*) as total_products
  from products
  group by factory,product_name
  order by factory,product_name;


-- COMMAND ----------

select
  factory,
  count(product_id) as num_products
  from 
  products
  group by factory
  order by 1;

-- COMMAND ----------

use practice_db;
with factorty_product_type AS (
  select 
  factory,
  product_name,
  count(product_id) as total_products
  from products
  group by factory,product_name
),
factory_produce_quantity AS (
  select
  factory,
  count(product_id) as num_products
  from 
  products
  group by factory
)
select 
  fpt.factory,fpt.product_name, fpq.num_products
from factorty_product_type fpt
left join factory_produce_quantity  fpq
on fpt.factory = fpq.factory 
order by fpt.factory,fpt.product_name;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Recursive CTE

-- COMMAND ----------

use practice_db;
select 
* 
from employee;

-- COMMAND ----------

select 
  e.id, e.name, e.dept,
  CONCAT(e.name, ' > ', eh.name)
  from employee e join employee eh
  on e.manager_id = eh.id

-- COMMAND ----------

WITH recursive emp_manager_rel (
  select 
  id, name, dept,
  name AS hirarchy
  from employee where manager_id is null
  UNION ALL 
  select 
  e.id, e.name, e.dept,
  CONCAT(e.name, ' > ', eh.name) as hirarchy 
  from employee e join employee eh
  on e.manager_id = eh.id
)
select * from emp_manager_rel

-- COMMAND ----------

