-- Databricks notebook source
-- MAGIC %md
-- MAGIC # PART III: PLAYER CAREER ANALYSIS

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. View the players table and find the number of players in the table

-- COMMAND ----------

use final_project;
select * from players;

-- COMMAND ----------

select 
count(playerid) as total_players, 
count(distinct playerid) as total_distinct_players
from players

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). Sort from longest career to shortest career.

-- COMMAND ----------

with player_info as (
  select 
    playerId,
    nameGiven,
    birthYear,
    birthMonth,
    birthDay,
    to_date(concat(birthYear,"-",birthMonth,"-",birthDay)) as birthDate,
    debut,
    finalGame
  from players
)
select 
playerid,
nameGiven,
birthDate,
debut,
date_diff(year,birthDate,debut) as age_at_debut,
finalGame,
date_diff(year,birthDate,finalGame) as age_last_game,
date_diff(year,debut,finalGame) as years_played
from player_info
order by years_played desc
;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. What team did each player play on for their starting and ending years?

-- COMMAND ----------

select * from salaries;

-- COMMAND ----------

with player_details_debut as (
  select 
    p.playerID,
    p.nameGiven,
    p.finalGame,
    year(p.debut) as debutYear,
    s.teamID as debutTeam
  from players p join salaries s
  on p.playerID = s.playerID AND year(p.debut) = s.yearID
),
player_details_retired as (
  select 
    p.playerID,
    p.nameGiven,
    p.finalGame,
    year(p.finalGame) retirementYear,
    s.teamID as retirementTeam
  from players p join salaries s
  on p.playerID = s.playerID AND year(p.finalGame) = s.yearID
)
select 
  pd.playerID,
  pd.nameGiven,
  pd.debutYear,
  pd.debutTeam,
  pr.retirementYear,
  pr.retirementTeam
from player_details_debut pd
join player_details_retired pr using (playerID)
order by pd.debutYear


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. How many players started and ended on the same team and also played for over a decade?

-- COMMAND ----------

with player_details_debut as (
  select 
    p.playerID,
    p.nameGiven,
    p.finalGame,
    p.debut,
    year(p.debut) as debutYear,
    s.teamID as debutTeam
  from players p join salaries s
  on p.playerID = s.playerID AND year(p.debut) = s.yearID
),
player_details_retired as (
  select 
    p.playerID,
    p.nameGiven,
    p.finalGame,
    p.finalGame,
    year(p.finalGame) retirementYear,
    s.teamID as retirementTeam
  from players p join salaries s
  on p.playerID = s.playerID AND year(p.finalGame) = s.yearID
)
select 
  pd.playerID,
  pd.nameGiven,
  pd.debut,
  pd.debutTeam,
  pr.finalGame,
  pr.retirementTeam,
  date_diff(year,pd.debut,pr.finalGame) career_years
  --count(pd.playerID) as total_players
from player_details_debut pd
join player_details_retired pr using (playerID)
where pd.debutTeam = pr.retirementTeam and date_diff(year,pd.debut,pr.finalGame) > 10
order by date_diff(year,pd.debut,pr.finalGame) desc
