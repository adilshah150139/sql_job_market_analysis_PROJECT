/*
Question: What are the most in-demand skills for data analysts?
 - Join job postings to inner join table similar to query 2
I dentify the top 5 in-demand skills for a data analyst.
 - Focus on all job postings.
  Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

SELECT 
   skills_dim.skill_id,
   skills,
   COUNT(sjd.job_id) AS demand_count
FROM
   skills_dim
JOIN  
   skills_job_dim sjd ON skills_dim.skill_id = sjd.skill_id
JOIN    -- just 'JOIN' mean inner join
   job_postings_fact jpf ON sjd.job_id = jpf.job_id
WHERE    
   jpf.job_title_short = 'Data Analyst' AND job_work_from_home = TRUE
GROUP BY
   skills_dim.skill_id
ORDER BY
   demand_count DESC
LIMIT 5;       -- top 5 skills
    
      