/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?

Purpose:
- Identify skills in high demand AND associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries

Why this matters:
- Targets skills that offer job security (high demand) AND financial benefits (high salaries)
- Offers strategic insights for career development in data analysis

Result:
- Returns skills with both high demand and high salary
- Helps decide which skills to prioritize learning
*/

-- using CTE to combine two table (top_demand_skills and top_paying_skills)

WITH skills_demand AS (  --CTE TABLE
    SELECT
      sjd.skill_id AS skill_id,
      sd.skills,
      COUNT(sjd.job_id) AS demand_count
    FROM skills_dim AS sd
    JOIN skills_job_dim sjd ON sd.skill_id = sjd.skill_id
    JOIN job_postings_fact jpf ON sjd.job_id = jpf.job_id
    WHERE
       jpf.job_title_short = 'Data Analyst' AND
       jpf.job_work_from_home = TRUE
    GROUP BY
       sjd.skill_id,
       sd.skills
), 
 average_salary AS ( --2nd CTE TABLE (for 2nd CTE table no need 'with')
    SELECT
       sjd.skill_id AS skill_id,
       ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM skills_dim AS sd
    JOIN skills_job_dim sjd ON sd.skill_id = sjd.skill_id
    JOIN job_postings_fact jpf ON sjd.job_id = jpf.job_id
    WHERE
      jpf.job_title_short = 'Data Analyst' AND
      jpf.job_work_from_home = TRUE AND
      jpf.salary_year_avg IS NOT NULL
    GROUP BY
      sjd.skill_id
)

SELECT
   skills_demand.skill_id,
   skills_demand.skills,
   average_salary.avg_salary,
   skills_demand.demand_count
FROM
   skills_demand
JOIN average_salary ON  skills_demand.skill_id = average_salary.skill_id
ORDER BY
  --- average_salary.avg_salary DESC,
   skills_demand.demand_count DESC,
   average_salary.avg_salary DESC
limit 10;