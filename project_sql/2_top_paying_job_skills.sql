/*
Question: What skills are required for the low-paying data analyst jobs?
- Use the 10 lowest-paying Data Analyst & Scientist jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH low_pay_job AS (
    SELECT	
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date:: date,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short IN ('Data Analyst','Data Scientist') AND 
        job_location IN ('Amsterdam, Netherlands','Utrecht, Netherlands') AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg
    LIMIT 10
)
SELECT
    low_pay_job.*,
    skills
FROM low_pay_job
INNER JOIN skills_job_dim ON low_pay_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg


-- Get count of skills
-- WITH table_count AS(
--     WITH low_pay_job AS (
--     SELECT	
--         job_id,
--         job_title,
--         job_location,
--         job_schedule_type,
--         salary_year_avg,
--         job_posted_date:: date,
--         name AS company_name
--     FROM
--         job_postings_fact
--     LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
--     WHERE 
--         job_title_short IN ('Data Analyst','Data Scientist') AND 
--         job_location IN ('Amsterdam, Netherlands','Utrecht, Netherlands') AND
--         salary_year_avg IS NOT NULL
--     ORDER BY salary_year_avg
--     LIMIT 10
-- )
-- SELECT
--     low_pay_job.*,
--     skills
-- FROM low_pay_job
-- INNER JOIN skills_job_dim ON low_pay_job.job_id = skills_job_dim.job_id
-- INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
-- ORDER BY salary_year_avg
-- )
-- SELECT 
--     COUNT(company_name) AS count,
--     skills
-- FROM table_count
-- GROUP BY skills
-- ORDER BY count DESC