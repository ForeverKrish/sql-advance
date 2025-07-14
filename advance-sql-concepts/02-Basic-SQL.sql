-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### SELECT & LIMIT

-- COMMAND ----------

use catalog `workspace`; select * from `practice_db`.`students` limit 100;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Big 6

-- COMMAND ----------

USE practice_db;

SELECT 
grade_level,avg(gpa) as avg_gpa, count(DISTINCT(school_lunch)) as lunch_count, max(gpa) - min(gpa) as range_gpa
FROM students
WHERE school_lunch = 'Yes' AND email is NOT NULL and email LIKE '%.com'
group by grade_level
having avg_gpa < 3.3
ORDER BY grade_level ASC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### CASE

-- COMMAND ----------

use practice_db;
select 
 student_name, grade_level,
 case
  when grade_level = 9 then 'Freshman'
  when grade_level = 10 then 'Sophomore'
  when grade_level = 11 then 'Junior'
  else 'Senior' 
end as student_class
from students;