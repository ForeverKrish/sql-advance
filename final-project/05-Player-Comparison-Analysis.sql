-- Databricks notebook source
-- MAGIC %md
-- MAGIC # PART IV: PLAYER COMPARISON ANALYSIS

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. View the players table

-- COMMAND ----------

select * from final_project.players;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. Which players have the same birthday?

-- COMMAND ----------

with player_details as (
  select 
    playerID,
    nameGiven,
    cast(CONCAT(birthYear,"-",birthMonth,"-",birthDay) as Date) playerBirthday
  from final_project.players
)
select 
  playerBirthday,
  listagg(nameGiven,", ") as players,
  count(playerID) as num_players
from player_details
where playerBirthday is not null
group by playerBirthday
having num_players > 1
order by num_players desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Create a summary table that shows for each team, what percent of players bat right, left and both

-- COMMAND ----------

select * from final_project.salaries;

-- COMMAND ----------

select
  s.teamID,
  ROUND(AVG(case when p.bats = 'R' THEN 1 else 0 end)*100,2) as player_bats_right_percent,
  ROUND(AVG(case when p.bats = 'L' THEN 1 else 0 end)*100,2) as player_bats_left_percent,
  ROUND(AVG(case when p.bats = 'B' THEN 1 else 0 end)*100,2) as player_bats_both_percent
from final_project.salaries s
join final_project.players p using (playerId)
group by s.teamID
order by teamId

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

-- COMMAND ----------

with player_cte(
  select 
    FLOOR(YEAR(debut)/10)*10 as debut_decade,
    ROUND(avg(weight),2) as avg_weight,
    ROUND(avg(height), 2) as avg_height
  from final_project.players
  where debut is not null
  group by debut_decade
),
player_decade_over_decade_cte(
  select 
    debut_decade,
    avg_weight,
    lag (avg_weight) over (order by debut_decade) as avg_weight_prev,
    avg_height,
    lag (avg_height) over (order by debut_decade) as avg_height_prev 
  from player_cte
)
select 
  debut_decade,
  avg_weight,
  avg_weight_prev,
  avg_weight - avg_weight_prev as avg_weight_change,
  avg_height,
  avg_height_prev,
  avg_height - avg_height_prev as avg_height_change
from player_decade_over_decade_cte
order by debut_decade
;