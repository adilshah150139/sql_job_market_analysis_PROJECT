/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment
*/


SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.salary_year_avg,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.job_posted_date
FROM job_postings_fact jpf
LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id
WHERE
    --jpf.job_title_short = 'Data Analyst'
     jpf.job_work_from_home = TRUE AND
     jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10;

