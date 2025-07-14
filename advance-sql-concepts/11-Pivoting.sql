-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Pivoting - Create Summary Table

-- COMMAND ----------

use practice_db;
select * from student_grades;

-- COMMAND ----------

select * from students;

-- COMMAND ----------

select 
  grades.department,
  student.grade_level,
  avg(final_grade) avg_grade
from student_grades grades
join students student
on grades.student_id = student.id
group by department,grade_level
order by 1,2

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Pivot grade_level column

-- COMMAND ----------

select 
grade.department,
avg(case when student.grade_level = 9 then grade.final_grade else null end) as freshman_grades,
avg(case when student.grade_level = 10 then grade.final_grade else null end) as sophomore_grades,
avg(case when student.grade_level = 11 then grade.final_grade else null end) as junior_grades,
avg(case when student.grade_level = 12 then grade.final_grade else null end) as senior_grades
from student_grades grade
join students student
on grade.student_id = student.id
group by grade.department
order by grade.department