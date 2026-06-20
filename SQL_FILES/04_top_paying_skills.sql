/*
Query 4
Scenario:
Answer: What are the top skills based on salary?
. Look at the average salary associated with each skill for Data Analyst positions
. Focuses on roles with specified salaries, regardless of location

. Why? It reveals how different skills impact salary levels for Data Analysts and helps identify
the most financially rewarding skills to acquire or improve
*/

SELECT
   skills_dim.skills AS skills,
   ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salaries,
   COUNT(sjd.job_id) AS demand_count
FROM 
   skills_dim
JOIN skills_job_dim sjd ON skills_dim.skill_id = sjd.skill_id
JOIN job_postings_fact jpf ON sjd.job_id = jpf.job_id
WHERE
    jpf.salary_year_avg IS NOT NULL
    AND
    jpf.job_title_short = 'Data Analyst'
    AND
    jpf.job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salaries DESC
LIMIT 10;