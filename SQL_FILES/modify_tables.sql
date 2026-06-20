-- LOAD DATA TO company_dim;
COPY company_dim
From 'E:\SQL\sql_job_market_analysis\datasets\company_dim.csv'
DELIMITER ',' CSV HEADER
ENCODING 'UTF8'
QUOTE '"';

DROP TABLE IF EXISTS job_postings_fact CASCADE;

-- Load data to job_postings_fact
COPY job_postings_fact
From 'E:\SQL\sql_job_market_analysis\datasets\job_postings_fact.csv'
DELIMITER ',' CSV HEADER;

-- CASCADE means to force the table and drop it whatever;
DROP TABLE IF EXISTS job_postings_fact CASCADE;

-- Load data to skills_dim
COPY skills_dim
FROM 'E:\SQL\sql_job_market_analysis\datasets\skills_dim.csv'
DELIMITER ',' CSV HEADER
ENCODING 'UTF8'
QUOTE '"';


-- LOAD DATA TO SKILLS_JOB_DIM TABLE:
COPY skills_job_dim
From 'E:\SQL\sql_job_market_analysis\datasets\skills_job_dim.csv'
DELIMITER ',' CSV HEADER
ENCODING 'UTF8'
QUOTE '"';



-- MODIFYING TABLE:
-- Count how many columns are in CSV vs your table
SELECT COUNT(*) as total_columns
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';


SELECT 
job_title_short AS job_title,
job_location,
job_posted_date::date
From job_postings_fact
LIMIT 10;

-- COUNT JOBS BY MONTHS;
SELECT 
  COUNT(job_id) AS job_posted_count,
  EXTRACT(MONTH FROM job_posted_date) AS month_date
From 
  job_postings_fact
WHERE
 job_title_short = 'Data Engineer'
GROUP BY
  month_date
ORDER BY
  job_posted_count DESC
LIMIT  10;