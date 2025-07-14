-- Databricks notebook source
-- MAGIC %md
-- MAGIC # PART II: SALARY ANALYSIS
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. View the salaries table

-- COMMAND ----------

use final_project;
select * from salaries;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Return the top 20% of teams in terms of average annual spending

-- COMMAND ----------

with expenditure_cte(
  select 
    teamID,
    yearID,
    sum(salary) as total_yearly_expd
  from final_project.salaries
  group by teamID,yearID
  ),
  avg_annual_expd_cte(
  select 
    teamID,
    avg(total_yearly_expd) as avg_yearly_expd,
    ntile(5) over(order by avg(total_yearly_expd) desc) as expd_bucket 
    from expenditure_cte
    group by teamID
  )
  select 
    teamID,
    round(avg_yearly_expd,2)
  from avg_annual_expd_cte
  where expd_bucket = 1

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. For each team, show the cumulative sum of spending over the years

-- COMMAND ----------

with expd_cte(
  select 
    yearID,
    teamID,
    sum(salary) as expd_per_year
  from final_project.salaries
  group by yearID,teamID
)
select
  yearID,
  teamID,
  expd_per_year,
  --sum(expd_per_year) OVER(PARTITION BY teamID ORDER BY yearID rows between unbounded preceding and unbounded following) as total_expd,
  sum(expd_per_year) OVER(PARTITION BY teamID ORDER BY yearID rows between unbounded preceding and current row) as cummulative_expd_sum
from expd_cte
order by teamID,yearID 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. Return the first year that each team's cumulative spending surpassed 1 billion

-- COMMAND ----------

with expd_cte(
  select 
    yearID,
    teamID,
    sum(salary) as expd_per_year
  from final_project.salaries
  group by yearID,teamID
),
cummulative_expd_cte(
  select
    yearID,
    teamID,
    expd_per_year,
    --sum(expd_per_year) OVER(PARTITION BY teamID ORDER BY yearID rows between unbounded preceding and unbounded following) as total_expd,
    sum(expd_per_year) OVER(PARTITION BY teamID ORDER BY yearID rows between unbounded preceding and current row) as cummulative_expd_sum
  from expd_cte
),
total_expd_billion as (
select 
  yearID,
  teamID,
  expd_per_year,
  cummulative_expd_sum,
  row_number() over(partition by teamID order by cummulative_expd_sum) as row_number
from cummulative_expd_cte
where cummulative_expd_sum >= 1000000000
),
distinct_teams as ( 
  select 
    distinct teamID 
  from final_project.salaries
)
select 
  teams.teamID,
  expd.yearID,
  expd.cummulative_expd_sum
from distinct_teams teams -- use to handle any teams which haven't crossed billion dollar mark
left join 
total_expd_billion expd
on teams.teamID = expd.teamID 
where row_number = 1
order by teamID 