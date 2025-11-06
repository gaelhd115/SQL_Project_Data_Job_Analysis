/*
Objective: Provide a list of jobs that show entry level jobs or jobs that are under $120,000 in California
- From the dataset, we seem to only have jobs posted from 2023, so we will be using that instead of 2025
*/

SELECT
    job_id,
    company_dim.name AS company_name,
    job_title,
    salary_year_avg,
    job_location,
    CASE
        WHEN salary_year_avg > 120000 THEN 'Not Likley'
        WHEN salary_year_avg BETWEEN 90000 AND 120000 THEN 'Possible'
        ELSE 'Likely'
    END AS acception_odds,
    job_posted_date

FROM job_postings_fact AS postings
    LEFT JOIN company_dim ON postings.company_id = company_dim.company_id

WHERE
    (job_title ILIKE '%Entry%' AND job_location LIKE '%CA%') AND
    salary_year_avg IS NOT NULL 
    AND EXTRACT(YEAR FROM job_posted_date) = 2023

ORDER BY
    salary_year_avg DESC

LIMIT 20;