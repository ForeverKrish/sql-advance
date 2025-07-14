-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Remove Duplicate

-- COMMAND ----------

USE practice_db;
select * from students;

-- COMMAND ----------

with student_cte as (
  select 
    id,
    student_name,
    email,
    rank() over(partition by student_name order by id desc) as rnk
  from students
)
select id, student_name, email from student_cte where rnk = 1

-- COMMAND ----------

select * from student_grades;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### MIN MAX Value filtering

-- COMMAND ----------

use practice_db;
with student_grade_cte(
  select 
    student_id,
    class_id,
    class_name,
    final_grade,
    rank() over (partition by student_id order by final_grade desc) as rnk
  from 
  student_grades
) 
select 
  cte.student_id,
  s.student_name,
  cte.class_id,
  cte.class_name,
  cte.final_grade 
from student_grade_cte cte join students s 
on cte.student_id = s.id
where rnk = 1
order by student_id
;