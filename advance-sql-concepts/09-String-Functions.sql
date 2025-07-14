-- Databricks notebook source
use practice_db;
select * from products;

-- COMMAND ----------

use practice_db;

select 
  factory, 
  product_id, 
  product_name,
  concat(replace(trim(factory)," ","-"),"-",trim(product_id),"-",replace(trim(product_name)," ","-")) as product_id_v2
from products

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Pattern Matching

-- COMMAND ----------

select 
  product_id, 
  product_name as product_name_old,
  replace(product_name,'Wonka Bar - ','') as product_name,
  factory,
  division,
  unit_price
from practice_db.products 
--where product_name like '%Wonka Bar%'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### NULL Functions

-- COMMAND ----------

select 
  product_id, 
  product_name,
  factory,
  COALESCE(division,'Other'),
  unit_price
from practice_db.products

-- COMMAND ----------

with factory_division_cte(with division_details(
  select 
    factory,
    division,
    count(division) as division_cnt
  from products 
  where division is not null
  group by 1,2
)
select
factory,
FIRST(division) OVER (partition by factory ORDER BY division_cnt DESC) popular_division
from
division_details
)
select 
  p.product_id, 
  p.product_name,
  p.factory,
  p.division,
  COALESCE(p.division,cte.popular_division,'Other') as divion_estd,
  p.unit_price
from products p join factory_division_cte cte using (factory)
;