# Introduction

Data analytics is rapidly growing. The global data analytics market is expected to increase from $23 billion USD in 2019 to [$133 billion USD by 2026](https://www.globenewswire.com/news-release/2021/02/08/2171129/0/en/Data-Analytics-Market-to-Hit-USD-132-90-Billion-by-2026-North-America-Region-to-Spearhead-the-Global-Data-Analytics-Industry-with-the-Projected-CAGR-of-26-4.html).
According to [The Future of Jobs 2020 Report](https://www.weforum.org/publications/the-future-of-jobs-report-2020/) developed by the World Economic Forum, more than 80% of the globally surveyed companies in the report have indicated that they'd have well adopted big data by 2025. 
With data analytics rapidly becoming a core component of businesses globally, the demand for data professionals is also on a rapid increase, with the [US Bureau of Labor Statistics](https://www.bls.gov/ooh/math/operations-research-analysts.htm) estimating a growth of 23% from 2022 to 2032 for data analyst jobs and decribing this growth as "much faster than the average for all occupations". 

Intrigued by these statistics and being in the data analytics field myslef, I wanted to dive deeper into the data job market, with a focus on remote data analyst roles. Specifically, I was interested in exploring the various kinds of data analyst roles, the in-demand and high paying skills for a data analyst, as well as the salary ranges for data analyst roles in the current job market. Through the analysis I will be addressing the following questions of interest:

1. What are the highest paying data analyst jobs?
2. Which skills are required for the highest paying jobs?
3. Which skills are in top demand for data analysts?
4. Which skills are associated with higher pay?
5. Which skills are the most optimal to learn?

# The Data and Tools

For this analysis, we are using a pre-cleaned dataset from Kaggle developed by Luke Barousse. This dataset contains scraped job postings from Google search results for Data roles in the United States. The data begins from the 4th November 2022 and updates daily. 

The dataset can be found [here](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search). 

Below is a simplified entity relationship diagram representing the dataset.

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/ec113c17-bc81-465e-a6e2-7e57240c0238)

*Image 1: Simplified Entity Relation Diagram (ERD) of the data.*

The following tools were utilised for the analysis:

* **SQL**: The programming language I used to query the database and extract insights.
* **PostgreSQL**: The database management system used to handle job posting data.
* **Visual Studio Code**: The source code editor used for database management and for the execution of SQL queries. Currently the most popular Integrated Development Environment (IDE) on the market due to it's key features such as wide language support, high customisability and large range of extensions to support coding workflow.
* **Git and Github** Git was the version control system I used to track my project code and revert back to previous versions if something went wrong. To share my project and allow collaboration with peers I used Github.

# The Analysis

## 1. Highest paying Data Analyst jobs

**Query:** 


```sql
-- Top 10 highest paying remote Data Analyst roles
SELECT	
	job_id
	, job_title
	, job_location
	, job_schedule_type
	, salary_year_avg
	, job_posted_date
	, name AS company_name
FROM
    job_postings_fact jbf
LEFT JOIN company_dim cd ON jbf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

```

**Output:**
![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/80c23400-a26d-4c64-9794-6877b3ee4ec3)

*Image 2: Query 1 Output.*

**Query Breakdown:**

In this query, I am querying from the job_postings_fact table, as this table contains the relevant information to answer the question such as the job title and yearly salary. Additionally, I chose to join the job_postings_fact table to the company_dim table using a left join to retrieve the name of the companies offering the role, whilst keeping all the rows from the job_postings_fact table. I aliased both tables in the FROM clause as best practice, as when writing longer queries it's ideal to use the alias of tables and columns to shorten code and improve readability. If there was a "name" column in the job_postings_fact table, I would've mentioned the "name" column from the company_dim column in the SELECT statement as "company_dim.name", to show that the name column is coming from the company_dim table and not the job_postings_fact table. In the WHERE clause, I chose to filter by Data Analyst roles only with the location set to "anywhere" (remote jobs), with the salary value not being a null. Finally, I ordered by the salary in descending order (highest to lowest) and limited the output to 10 rows. 

**Insights:**
* **Broad Salary Range:** The top 10 paying Data Analyst roles range from $184,000 to $650,000 USD, indidicating a strong salary potential in the field.
* **Employer Diversity:** Top paying Data Analyst jobs span across various industries such as information technology (Meta), telecommunications (AT & T), Marketing/Social Media (Pinterest) and Health (UCLA Health). This portrays that top salaries are available across a range of different industries and aren't limited to a select few. 
* **Job Title Variation:** There are diverse job titles in the feild including Data Analyst, Principal Data Analyst, Associate Director and Director of Analytics, reflecting the various roles and levels within the field.

**Visualisation**

The results of the query were exported as a CSV file from VS Studio, from there I visualised the results using Excel. 

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/242e6efd-1395-482d-85e3-2c2d5dfaa590)

*Image 3: Bar Graph for Top 10 Data Analyst roles based on average annual salary.* 



## 2. Skills for highest paying jobs

**Query:**

```sql
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
```

**Output (only the first 3 jobs not the full results)**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/df3d1b1f-355d-4cc4-b410-2db6693bc71e)

*Image 4: Query 2 Output.*


**Query Breakdown**
Using Query #1 I was able to retrieve the top 10 highest paying remote data analyst jobs. With Query #2 my aim was to look at the skills associated with these top 10 highest paying remote analyst jobs. In order to do this, I had to join the results of Query #1 to the skills_job_dim table which contains the skill id, then join the skills_job_dim table with the skills_dim table to retrieve the skill name. Rather than re-writing Query #1 and using a subquery, I chose to modify it into a CTE (top_paying_jobs) to shorten the code and improve readability. I kept Query #1 the same, as our criteria and conditions were unchanged, but left only the columns for retrieval in the SELECT statement which I felt were relevant in addressing the question. To obtain the skills, I utilised inner joins in the main query to firstly connect the top_paying_jobs CTE to the skills_job_dim table, and then to connect the skills_job_dim table to the skills_dim table. 

Out of the top 10 highest paying remote data analyst jobs we found, the top two jobs (Data Analyst at Mantys and Director of Analytics at Meta), did not have have skills associated with them, hence, these were omitted from the visualisation below. Thereby, the visualisation below showcases the skill count for only the 8 remote data analyst following the top two which we omitted.

**Visualisation**

The results of Query #2 were also exported as a CSV file from VS Studio, from there I visualised the results using Excel. 

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/0d699c22-1923-489c-8392-71784c9d993f)

*Image 5: Bar Graph for the count of skills for top 8 Data Analyst roles.*



**Insights:** 
For the top 8 highest paying remote Data Analyst jobs, after omitting the top two jobs, SQL is a required skill for all 8 roles and leads all the other skills. Generally, a traditional data analyst toolkit comprises of tools such as SQL (to query databases), python (for advanced analyses) or R (for advanced analyses/statistical analyses), tableau (for dashboards and visualisations) and Excel. With these comprising a traditional data analyst toolkit, it makes sense for the top skills to comprise of these skills. More niche skills such as cloud based skills can be expected to be required for lesser roles, as reflected in the visualisation. 

## 3. The most in-demand skills for Data Analysts

**Query:**

```sql
-- Top 5 most demanded skills for Data Analyst job postings
SELECT 
    skills_dim.skills
    , COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

**Output:**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/38d773e2-eda8-432d-aec2-2016e7a7e697)

*Image 6: Query 3 Output.


**Query Breakdown**

The aim of this query was to identify the most in-demand skills for data analysts, by focusing on all job postings, rather than the top paying job postings. In order to do this, I had calculate how many times a skill showed up in the job postings (count of skills). Much of the query will be similar in structure to the main query in Query #2, however instead of the top_paying_jobs CTE, we had to utilise inner joins to connect the job_postings_fact table with the skills_job_dim table, which would then connect to the skills_dim table to retrieve the skill names linked to each job posting. The SELECT statement comprises of the skills column in order to retrieve the skill name, and the COUNT function in order to count how many times each skill appears in job postings. The filters in the WHERE clause will remain the same, as we're still filtering by remote Data Analyst roles. The GROUP BY clause was used due to the COUNT aggregation in the SELECT statement, which will group the count by each skill. Finally, I ordered by the count of skills in descending order (highest to lowest) and limited the output to 5, resulting in only the top 5 most in demand skills.

**Insights:**

With **SQL** and **Excel** being fundamental data analyst skills, it's no surprise that these skills are the most in demand. This emphasises the need for strong foundational skills in database querying and spreadsheets. **Python**, **Tableau** and **Power BI** are next on the list, showcasing the importance of technical skills in advanced analyses and data visualisation. 


## 4. Skills associated with higher pay

Query:

```sql
-- Average salary for job postings by individual skill
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

Output:

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/9cc60cf1-be93-46e9-b79a-3418b0095533)

*Image 7: Query 4 Output.*




**Query Breakdown**

With this query, my aim was to calculate the average yearly salary per skill for Data Analyst roles. 
The structure of this query is almost identical to Query #3, however instead of using the COUNT function we have used the AVG function in the SELECT statement to get the average salary in job postings, rounded to 2 decimal places using the ROUND function. We will once again query the job_postings_fact table, joined to the skills_job_dim table and skills_dim table in order to connect the skills to each job posting.  
The filtering in the WHERE clause will remain similar, as we're still interested in remote Data Analyst roles, however, this time I have included the IS NOT NULL operator to filter for roles with a salary value. Since we have used the AVG aggregation in the SELECT statement, we have used a GROUP BY clause to group the average salaries by skill. Finally, the results will be limited to 25 rows, sorted in descending order (highest to lowest) by average salary.

**Insights:**

The top paying skills revolve around large scale data processing tools such as PySpark and Couchbase, machine learning tools such as DataRobot and Jupyter, Python libraries like Pandas and NumPy and cloud computing tools such as Elasticsearch and Bitbucket. This showcases the high value placed on skills involving big data technologies, predictive modelling and cloud analyics in the Data Analyst job market. 

## 5. Most optimal skills to learn

**Query:**

```sql
-- Finding the most optimal skills (high demand and high pay)
SELECT
  skills_job_dim.skill_id
  , skills_dim.skills 
  , COUNT(skills_job_dim.job_id) as demand_count
  , ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
  job_postings_fact
INNER JOIN
skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst'
  AND job_postings_fact.salary_year_avg IS NOT NULL
  AND job_postings_fact.job_work_from_home = True
GROUP BY
  skills_job_dim.skill_id
  , skills_dim.skills
HAVING
  COUNT(skills_job_dim.job_id) > 10
ORDER BY
  avg_salary DESC,
  demand_count DESC
LIMIT 25;

```

**Output**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/6963987c-c055-4b45-8150-930842aeb7ee)

*Image 8: Query 5 Output.*



**Query Breakdown**

This query aimed to identify "optimal" skills, that is, skills which are in high demand and are also associated with high average salaries for remote Data Analyst roles. Exploring these skills can help with targeting skills that offer job security (high demand) and financial benefits (high salaries).

This query could have been structured in a different way than above, for example, a CTE could have been assigned to both Query #3 and Query #4, as we had already found the most in demand skills and the average salary for skills, these CTE's could have been combined to produce the same output. However, the code would have been lengthy, and I found the above structure more efficient and easier to read.
In the SELECT statement I wanted to retrieve the skill id, the skill name, the average salary of each skill (rounded to 2 decimal places) and the COUNT of job id's to count how often each skill appears in job postings. Then in the FROM clause, similar to previous queries, I joined the job_postings_fact table with the skills_job_dim table, which was then joine with the skills_dim table using inner joins, allowing skills to be connected to each job posting. The filters in the WHERE clause remain the same as Query #1 and Query #4, as we're still interested in remote Data Analyst roles with no null values for the salary. However, the HAVING clause has been used as I wanted to filter by the aggregated demand_count column, including only those skills that have shown up more than 10 times in job postings. This is because,  without filtering for skills that didn't show more than 10 times across the job postings, I was left with low demand but high paying skills. With the COUNT aggregation in the SELECT statement, I also had to use the GROUP BY clause and group by by skill id. Typically you would include all columns in the SELECT statement other than the column being aggregated in the GROUP BY clause, however, since I was grouping a primary key I didn't need to in this case. 

**Insights**




