/*
Question: What are the top-paying data analyst jobs?
- Identify the top 15 highest-paying Data Analyst roles that are available in California, New York, Washington, and Texas
- Focus on job postings with specified salaries (remove nulls)
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into optimal skills/roles
*/

WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
        LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
            (job_location LIKE '%CA%' OR
            job_location LIKE '%NY%' OR
            job_location LIKE '%WA%' OR
            job_location LIKE '%TX%') AND
        salary_year_avg IS NOT NULL AND
        salary_year_avg < 120000
    ORDER BY
        salary_year_avg DESC
    LIMIT 15
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY
    salary_year_avg DESC