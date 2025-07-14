-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Subqueries

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Inner Query inside select

-- COMMAND ----------

use practice_db;

Select 
year,country,happiness_score,
(Select avg(happiness_score) from happiness_scores) AS avg_hs,
happiness_score - (Select avg(happiness_score) from happiness_scores) AS diff
from happiness_scores;

-- COMMAND ----------

use practice_db;
select 
product_id,product_name,
unit_price - (select avg(unit_price) from products) as diff_price
from products 
order by unit_price desc;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Subquery in FROM

-- COMMAND ----------

use practice_db;

select 
  p.factory,
  p.product_name,
  tmp.product_count
from products p 
left join 
(
  select 
    factory,
    count(product_id)  product_count
  from products
  group by factory
) tmp on p.factory = tmp.factory


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### SubQuery in WHERE

-- COMMAND ----------

USE practice_db;
SELECT 
*
from products 
WHERE unit_price < (SELECT min(unit_price) FROM products WHERE factory = "Wicked Choccys")
order by product_id;


