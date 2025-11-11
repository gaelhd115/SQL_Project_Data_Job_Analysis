# Introduction

For this project, I will be going over the data analyst job market according to my situation. My situation being a post-graduate looking for entry level data analyst jobs in states such as California, Washington, New York, and Texas. I will be focusing on four topics, this includes top-paying jobs, in-demand skills, how top-paying jobs correlate with in-demand skills, and what my job search looks like in California.

- These are the SQL queries that I worked on: [project_sql_folder](/project_sql/)

# Background

I was motivated to learn SQL after finding out that it was the most sought after skill in the data anlyst job market. Afterwards, I delved into a SQL course to introduce myself the programming language to find out more information about the top skills and top paying jobs.

The data that was gathered also came from the [SQL course](https://www.lukebarousse.com/sql). The data includes more than just data analyst jobs but also data scientist and machine learning engineers while also including job titles, locations, posted dates, etc.

### Questions that were answered through my queries:

1. What are the top-paying data analyst jobs?
2. What skills are used for those top-paying data analyst jobs?
3. What are the most in-demand skills for data analysts?
4. What are the top skills based on salary?
5. What are the most optimal skills to learn (high demand and a high-paying skill)?
6. What would my job search look like?

# Tools I Used

In order to start my data analysis project, 

- **SQL**: the core of the project was built using this language as it allows to manage the data neatly
- **PostgreSQL**: a database managment system that I chose due to its popularity and solid foundation when dealing with extensible relational databases
- **Visual Studio Code**: a code editor that I have been familiar with for some time so using this tool was fairly easy for me in executing the SQL code
- **Git and Github**: essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking

# Analysis
As said earlier, the goal of this project was to look into specific aspects of the data analyst job market. Below are the queries that I worked on and approach to each question:

### 1. Top Paying Data Analyst Jobs
To find the highest paying roles in California, Washington, New York, and Texas, I filtered by the average yearly salary (limiting to just jobs under $120,000) and the location. Only focused on said states while also filtering out jobs that were remote. The reason for filtering out remote jobs is that I learn better in person when I see what others are doing and it being easier for me to ask for help. I also didn't want to find jobs that didn't specify a salary so I just removed those null values from the data.

```sql
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
LIMIT 15;
```
Here is the breakdown of what I found from the top paying data analyst jobs in 2023:
- **Salary Insights**: Although I did limit the dataset to only include jobs with an average yearly salary of $120,000, we can still notice that the top 15 jobs have about $2,000 difference ranging from $117,500 to $119,150. 
- **Geographic Location**: With the four states that I filtered for, the result shows there being a tie between Texas and California with 6 job postings each, New York with 3 job postings, and Washingtion with 0.
- **Employer Diversity**: There is a broad spectrum of companies like Liberty Mutual, TikTok, and American Express that offer a high paying salary which shows that there is many companies that take interest in data analysts.

### 2. Top Paying Job Skills
After finding out which jobs offered the highest salary within my range, I now had to find which skills were often sought after from employers. Using the basic structure from the first query as well as the same WHERE statement, I created a CTE named top_paying_jobs then joined it to skills_job_dim and skills_dim in order to link the skills to each job_id.

```SQL
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
    salary_year_avg DESC;
```
Below is the breakdown for the top paying job skills:
- **SQL Dominance**: Aside from one company in the top 15 job postings, SQL was always listed as a skill required
- **Runner Ups**: Other common skills from the companies seen in the results of the first query were Python, Excel, and Tableus.

### 3. Top In-Demand Skills
Explanation of Query
In this query, I was looking for the top skills not only in the high paying jobs but in all data analyst jobs. In this query, I decided to count the job_id and group them by skills so that it'll show the amount of a certain skill is found in the postings. I also filtered in the WHERE statement to only include data analysts and remove any postings that allowed work from home.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = FALSE 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here is the breakdown of the top in-demand skills below:
- **Top 5**: From most demanded skill to least (within top 5 in-demand skills), SQL in first with 85,337, Excel with 62,420, Python with 52,996, Tableau with 42,809, and Power Bi with 36,859 postings that ask for this skill. This aligns to what we saw in the top paying data analyst job skills seeing that SQL is the clear winner in demanded skill.

| Skill     | Demand Count |
|----------|--------------|
| SQL      | 85,337       |
| Excel    | 62,420       |
| Python   | 52,996       |
| Tableau  | 42,809       |
| Power BI | 36,859       |

*Here is the table showing the top 5 most in demand skills in the data analyst job postings*

### 4. Top Paying Skills
Now we are searching for which skills pay the most being a data analyst. For this query, I kept a similar structure as the top demanded skills query but instead we are looking for the average yearly salary and ordering them from top paid to least paid. I also decided to limit the table to just 25.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = FALSE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```
The breakdown of the query is down below:
- **Specialized Skills**: The top paying skills aren't as common as SQL or Tableau, they are specialized skills that many candidates aren't going to have but are still asked from companies which is the reason for the extremely high average salary.
- **DevOps**: Skills like golang, vmware, and terraform are well compensated, ranging from $146,734 to $165,000, due to its ties to deployment, automation, and distributed systems.

### 5. Optimal Skills
Explanation of query
Combining all that I learned so far, this query takes the demand count from top demanded skills and the average salary from top paying skills to join with their according skill id. Sinply put, I gathered the top 25 demanded skills and applied its average salary along with it.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = FALSE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25
```
The breakdown of the query is shown below:
- **Average Yearly Salary**: The range of salary from the most demanded skills is $82,000 to $114,000
- **Fall Off**: After the top 4 demanded skills, that being SQL, Excel, Python, and Tableau, there is significant decrease in demand. Almost 500 job postings decrease from Tableau to the fifth demanded skill but there doesn't seem to be much difference in the average yearly salary.

# What I Learned
After nearly two months of studying SQL, I have applied what I learned from the course to this project:
- **The Basics**: Going from not knowing to the langauge of SQL, I learned to use subqueries to manage smaller datasets, CTEs to get a temproary result that I can then reference, and the order of statements from SELECT to LIMIT.
- **Github**: Although I had some experience using Github, this is one of few times using it to push my project onto my on profile for the rest of the internet to see.
- **Analytical Upgrades**: Practicing using a real dataset has taught me to turn questions into actions, solve problems found in the in real world, and adapt to problems using what is needed.

# Conclusion

This project is still a work in progress but I wanted to show off what I have been working on. The sixth query is what I want to finish soon before I apply to even more jobs than what I already applied for. I have learned and enhance my skills as a SQL user so that I can be seen as more valuable fit as a data analyst while also showcasing my findings in this project on the prioritizing of skills and the pay in this job market.