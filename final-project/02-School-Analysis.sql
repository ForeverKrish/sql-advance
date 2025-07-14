-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### PART I: SCHOOL ANALYSIS

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. View the schools and school details tables

-- COMMAND ----------

use final_project;
select 
*
from schools
order by yearID;

-- COMMAND ----------

select * from final_project.school_details;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. In each decade, how many schools were there that produced players?

-- COMMAND ----------

use final_project;
with schools_cte(
  select 
    yearID,
    FLOOR(yearID/10)*10 as decadeID,
    count(distinct schoolID) as school_count
  from schools
  group by yearID
)
select 
  decadeID,
  sum(school_count) as total_schools
from schools_cte
group by decadeID
order by decadeID
;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. What are the names of the top 5 schools that produced the most players?

-- COMMAND ----------

with schools_cte(
  select 
    schoolID,
    count(distinct playerID) as total_players
  from
  schools
  group by schoolID 
),
ranked_schools_cte(
  select 
    schoolID,
    total_players,
    dense_rank() over (order by total_players desc) rnk
  from schools_cte
)
select 
--school.schoolID,
school_details.name_full as school_name,
school.total_players
from 
ranked_schools_cte school
left join school_details school_details using (schoolID)
where school.rnk <= 5 



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. For each decade, what were the names of the top 3 schools that produced the most players?

-- COMMAND ----------

use final_project;
with school_cte as (
  select 
    FLOOR(yearID/10) * 10 as decadeID,
    schoolID,
    count(distinct playerID) as total_players
  from schools 
  group by decadeID,schoolID
),
top_school_cte (
  select 
    decadeID,
    schoolID,
    total_players,
    ROW_NUMBER() over (partition by decadeID order by total_players desc) as rn
  from school_cte
)
select 
  sch.decadeID,
  --sch.schoolID,
  sch_details.name_full as school_name,
  sch.total_players
from top_school_cte  sch
join school_details sch_details using (schoolID)
where sch.rn <= 3
order by sch.decadeID, sch.rn 
;


-- COMMAND ----------


