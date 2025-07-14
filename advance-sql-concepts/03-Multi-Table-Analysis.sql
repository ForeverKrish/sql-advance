-- Databricks notebook source
use practice_db;
select * from happiness_scores;

-- COMMAND ----------

select * from country_stats;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### ## Joins

-- COMMAND ----------

select 
  hs.country, 
  hs.happiness_score, 
  cs.life_expectancy,
  cs.population
from happiness_scores hs
join country_stats cs 
ON hs.country = cs.country

-- COMMAND ----------

select 
  hs.country, 
  hs.happiness_score, 
  cs.life_expectancy,
  cs.population
from happiness_scores hs
left join country_stats cs 
ON hs.country = cs.country 
order by cs.country

-- COMMAND ----------

select 
  hs.country, 
  hs.happiness_score, 
  cs.life_expectancy,
  cs.population
from happiness_scores hs
right join country_stats cs 
ON hs.country = cs.country 
order by hs.country

-- COMMAND ----------

select 
  hs.country, 
  hs.happiness_score, 
  cs.life_expectancy,
  cs.population
from happiness_scores hs
full outer join country_stats cs 
ON hs.country = cs.country 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Pick a final JOIN type to join products and orders

-- COMMAND ----------

select * from orders;

-- COMMAND ----------

select * from products;

-- COMMAND ----------

select * 
from products pd
left join orders or
on pd.product_id = or.product_id

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Self Joins

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Which products are within 25 cents of each other in terms of unit price?

-- COMMAND ----------

select 
  p1.product_name as product1,
  p2.product_name as product2,
  ABS(p1.unit_price - p2.unit_price) AS diff_price_flag
from products p1
inner join products p2 
on p1.product_id <> p2.product_id 
where ABS(p1.unit_price - p2.unit_price) < 0.25 
and p1.product_id < p2.product_id -- remove duplicate
order by diff_price_flag

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Join the products table with itself so each candy is paired with a different candy

-- COMMAND ----------

select distinct(division) from products;

select 
p1.product_id,
p1.division,
p2.product_id,
p2.division
from
products p1
left join products p2
on p1.product_id <> p2.product_id and p1.division <> p2.division 
where p1.division is not null and p2.division is not null and p1.division < p2.division 
order by p1.product_id,p1.division,p2.product_id,p2.division