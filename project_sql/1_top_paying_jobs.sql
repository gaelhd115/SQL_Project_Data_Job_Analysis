/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available in Los Angeles, San Diego, Seattle, New York
- Focus on job postings with specified salaries (remove nulls)
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into optimal skills/roles
- Limiting the salary average to $120,000 for estimated high paying entry level jobs
*/

SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
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