# 📊 SQL Job Market Analysis for Data Analysts


## 🎯 Project Overview

This project analyzes job postings data to answer **5 key questions** about the Data Analyst job market:

1. **What are the top-paying jobs?**
2. **What skills are required for top-paying roles?**
3. **What are the most in-demand skills?**
4. **What are the top skills based on salary?**
5. **What are the most optimal skills to learn?** (High Demand + High Paying)

🔍 SQL queries? Check them out here: [sql_job_market_analysis folder](/SQL_FILES/)

---

## 🛠️ Technologies & SQL Concepts Used

### Software & Tools
| Tool | Purpose |
|------|---------|
| PostgreSQL | Database to store, filter and query job market dataset |
| VS Code | Main code editor for writing & running all SQL scripts |
| Git & GitHub | Version control + host project as portfolio repo |

### Core SQL Skills Applied in Analysis
| SQL Feature / Function | How I Used It |
|------------------------|---------------|
| COUNT(), SUM(), AVG() | Aggregate functions to calculate job counts, average salaries |
| GROUP BY / HAVING | Group data by job title, skill, company to find trends |
| INNER / LEFT JOIN | Combine 4 separate CSV tables from the star schema |
| CTEs (WITH clauses) | Break long complex queries into readable steps |
| Subqueries & Nested Queries | Filter datasets before main aggregation |
| CASE Statements | Create custom salary categories & skill groups |

---

## 📁 Database Schema

The project uses a **star schema** with 4 tables:

### `job_postings_fact`
- `job_id` (Primary Key)
- `company_id` (Foreign Key)
- `job_title`, `job_title_short`
- `job_location`, `job_work_from_home` (Remote)
- `salary_year_avg`, `salary_hour_avg`
- `job_posted_date`

### `company_dim`
- `company_id` (Primary Key)
- `name`, `link`, `link_google`, `thumbnail`

### `skills_dim`
- `skill_id` (Primary Key)
- `skills`, `type`

### `skills_job_dim` (Bridge Table)
- `job_id`, `skill_id` (Composite Primary Key)
- Foreign Keys to `job_postings_fact` and `skills_dim`

---

## 📊 Key Queries & Results

### 📌 Query 1: Top-Paying Data Analyst Jobs

**Purpose:** Identify the highest-paying Data Analyst roles (remote).

**Query:** [`01_top_paying_jobs.sql`](/SQL_FILES/1_top_paying_jobs.sql)

```sql
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
    jpf.job_title_short = 'Data Analyst'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10;
```

**Results:**

## 📊 Top 10 Highest Paying Jobs - Visualization


### 📊 Salary Distribution by Job Title

```
Job Title               Count   Average Salary
─────────────────────────────────────────────────
Data Scientist          6       ~$437,000
Data Analyst            2       ~$493,000
Data Engineer           2       $325,000
Senior Data Scientist   2       $425,000
```

---

### 🎯 Job Title Breakdown

```
        Data Scientist (60%)
        ┌─────────────────────┐
        │                     │
        │    ████████████     │  ██ Data Scientist (6)
        │    ████████████     │  ██ Data Analyst (2)
        │    ████████████     │  ██ Data Engineer (2)
        │    ████████████     │  ██ Senior Data Scientist (2)
        │                     │
        └─────────────────────┘
```

---


### 📊 Quick Stats Visual

```
Highest Salary:     $650,000  ████████████████████████████████████
Lowest Salary:      $325,000  ██████████████████
Average Salary:     $428,000  █████████████████████████
Remote Positions:   100%      ████████████████████████████████████
Data Scientist:     60%       ████████████████████████████
```
---

### 📌 Query 2: Most In-Demand Skills for Data Analysts
**Purpose:** Identify the specific skills required for the highest-paying Data Analyst roles
**Query File:** [`02_top_demanded_skills.sql`](/SQL_FILES/2_top_paying_job_skills.sql)

```sql
WITH top_paying_jobs AS (         -- Using CTE (Common Table Expression)
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name as  company_name
FROM
   job_postings_fact
LEFT JOIN
   company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
     job_title_short = 'Data Analyst' AND
     job_location = 'Anywhere' AND
     salary_year_avg IS NOT NULL
ORDER BY
     salary_year_avg DESC
LIMIT 10
)
SELECT top_paying_jobs. *,
skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
   salary_year_avg DESC     -- this query may or may not necessary, because we have already write it there in the CTE. but its good write it.
LIMIT 10;
```
## Result:
## 📊 Skill Frequency Analysis for Top-Paying Data Analyst Roles
| Skill  | Frequency | % of Top Jobs |
|--------|-----------|---------------|
| Python | 2/2       | 100%          |
| SQL    | 1/2       | 50%           |
| R      | 1/2       | 50%           |
| SAS    | 1/2       | 50%           |
| MATLAB | 1/2       | 50%           |
| Pandas | 1/2       | 50%           |
| Tableau| 1/2       | 50%           |
| Looker | 1/2       | 50%           |

## 💡 Key Insights


| Insight | Why It Matters |
|---------|----------------|
| Python is non-negotiable | Required in 100% of top-paying Data Analyst roles |
| Variety matters | Top companies look for candidates with 8+ different skills |
| Full-stack data skills | SQL + Python + R + SAS + MATLAB = statistical + programming + analytics expertise |
| Visualization is valued | Tableau + Looker consistently appear within top-paying roles |
| Data science overlap | Pandas + R + Python build a strong foundational data science skill set |

---

### 📌 Query 3: Most In-Demand Remote Data Analyst Skills
**Objective:** Find the top 5 most frequently required skills for fully remote Data Analyst roles by counting skill occurrences across all remote job postings.
**Source Script:** [`03_top_demanded_skills.sql`](/SQL_FILES/03_top_demand_skills.sql)

```sql
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
```

## 🟰 Result

### Sample Query Output
| skill_id | skills  | demand_count |
|----------|---------|--------------|
| 0        | sql     | 1706         |
| 1        | python  | 992          |
| 181      | excel   | 908          |
| 182      | tableau | 860          |
| 183      | power bi| 601          |

### 📝 Quick Summary
- SQL is the most sought-after skill, appearing in 1706 listings.
- Python, Excel, Tableau, and Power BI round out the top five required tools.
- These five skills are core requirements for anyone pursuing remote Data Analyst positions.

---
### 📌 Query 4:  Top Skills Based on Average Salary

**Objective:** Identify which technical skills for Data Analysts are associated with the highest average annual salaries.

**Source Script:** [04_top_paying_skills.sql](/SQL_FILES/04_top_paying_skills.sql)

``` sql
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
```
### Sample Query Output
| skills        | avg_salaries | demand_count |
|---------------|--------------|--------------|
| golang        | 145000       | 1            |
| kubernetes    | 145000       | 1            |
| elasticsearch | 145000       | 1            |
| swift         | 140500       | 1            |
| pandas        | 125913       | 5            |
| scikit-learn  | 125781       | 2            |
| gcp           | 123750       | 2            |
| databricks    | 120000       | 2            |
| numpy         | 118281       | 2            |
| vba           | 115000       | 1            |

### 📝 Quick Summary
- Specialized engineering and big data tools (Golang, Kubernetes, Elasticsearch) deliver the highest average salaries, though they appear in very few job postings.
- Data science libraries (Pandas, NumPy, Scikit-learn) offer strong pay alongside higher market demand.
- Cloud and big data platforms like GCP and Databricks also provide competitive salary packages for Data Analysts.

---

### 🎯 Query 5: Most Optimal Skills to Learn (High Salary + High Demand)
**Objective:** Identify skills that balance strong market demand and high average salary — the best skills for Data Analysts to prioritize learning.
**Source Script:** [`05_optimal_skills.sql`](/SQL_FILES/05_most_optimal_skills.sql)

```sql
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
```
### Sample Query Output
| skill_id | skills  | avg_salary | demand_count |
|----------|---------|------------|--------------|
| 0        | sql     | 90624      | 1706         |
| 1        | python  | 95080      | 992          |
| 181      | excel   | 85326      | 908          |
| 182      | tableau | 93863      | 860          |
| 183      | power bi| 91098      | 601          |
| 5        | r       | 93704      | 483          |
| 185      | looker  | 98128      | 216          |
| 186      | sas     | 89859      | 197          |
| 7        | sas     | 89859      | 197          |
| 74       | azure   | 88292      | 192          |
### 📝 Quick Summary
- SQL has far and away the highest job demand among remote Data Analyst skills, appearing in 1706 postings.
- Python delivers the second-highest demand alongside a strong average salary of $95,080.
- Visualization tools Tableau, Power BI and Looker offer solid pay, with Looker having the highest average salary in this group.
- Excel is widely required but carries the lowest average salary out of all listed core skills.
- Cloud and statistical tools like Azure, R and SAS have moderate to low market demand.

---

## 🏁 Conclusion

This project analyzed remote Data Analyst job postings using **PostgreSQL** and a **star-schema dataset**. Through **five SQL queries**, I identified:

1. **Top-paying jobs** — up to $165,000/year  
2. **Skills for high-paying roles** — Python is mandatory (100%)  
3. **Most in-demand skills** — SQL (1,706 jobs)  
4. **Skills with highest salary** — Pandas ($125,913)  
5. **Optimal skills** — Python + SQL + Tableau (high demand + high pay)

---

### 🛠️ Technical Skills Applied

- `JOIN`, `CTE`, `GROUP BY`, `HAVING`, `ORDER BY`
- Aggregate functions (`COUNT`, `AVG`)
- Data filtering and sorting

---

### 💡 Key Takeaway

> **Python and SQL are the foundation. Add Tableau or Pandas to stand out and earn more.**

---

### 🚀 What I Learned

- How to turn business questions into SQL queries  
- How to extract actionable insights from raw data  
- How to structure and document a complete data project

---

**This project proves I can analyze, interpret, and present data professionally using SQL.**