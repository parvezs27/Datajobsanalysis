-- Top 10 paying Data Analyst jobs
WITH top_paying_jobs AS (
    SELECT	
        job_id
        , job_title
        , salary_year_avg
        , name AS company_name
    FROM
        job_postings_fact jpf
    LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
-- Skills required for Data Analyst jobs
SELECT 
    top_paying_jobs.*
    , skills
FROM top_paying_jobs
INNER JOIN skills_job_dim sjd ON top_paying_jobs.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY
    salary_year_avg DESC;