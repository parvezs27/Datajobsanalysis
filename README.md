# Introduction

Data analytics is rapidly growing. The global data analytics market is expected to increase from $23 billion USD in 2019 to [$133 billion USD by 2026](https://www.globenewswire.com/news-release/2021/02/08/2171129/0/en/Data-Analytics-Market-to-Hit-USD-132-90-Billion-by-2026-North-America-Region-to-Spearhead-the-Global-Data-Analytics-Industry-with-the-Projected-CAGR-of-26-4.html).
According to [The Future of Jobs 2020 Report](https://www.weforum.org/publications/the-future-of-jobs-report-2020/) developed by the World Economic Forum, more than 80% of the globally surveyed companies in the report have indicated that they'd have well adopted big data by 2025. 
With data analytics rapidly becoming a core component of businesses globally, the demand for data professionals is also on a rapid increase, with the [US Bureau of Labor Statistics](https://www.bls.gov/ooh/math/operations-research-analysts.htm) estimating a growth of 23% from 2022 to 2032 for data analyst jobs and decribing this growth as "much faster than the average for all occupations". 

Intrigued by these statistics and being in the data analytics field myslef, I wanted to dive deeper into the data job market, with a focus on remote data analyst roles. Specifically, I was interested in exploring the various kinds of data analyst roles, the in-demand and high paying skills for a data analyst, as well as the salary ranges for data analyst roles in the current job market. 

Through the analysis I will be addressing the following questions of interest:

1. What are the highest paying data analyst jobs?
2. Which skills are required for the highest paying jobs?
3. Which skills are in top demand for data analysts?
4. Which skills are associated with higher pay?
5. Which skills are the most "optimal" to learn?

# The Data and Tools

For this analysis, we are using a pre-cleaned dataset from Kaggle developed by Luke Barousse. This dataset contains scraped job postings from Google search results for Data roles in the United States. The data begins from the 4th November 2022 and updates daily. 

The dataset can be found [here](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search). 

The SQL queries I used to create the tables can be found here: [sql_load folder](/sql_load/)

The SQL queries I used to address the questions can be found here: [project_sql folder](/project_sql/)

Below is a simplified entity relationship diagram representing the dataset.

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/ec113c17-bc81-465e-a6e2-7e57240c0238)

*Image 1: Simplified Entity Relation Diagram (ERD) of the data.*

The following tools were utilised for the analysis:

* **SQL**: The programming language I used to query the database and extract insights.
* **PostgreSQL**: The database management system used to handle job posting data.
* **Visual Studio Code**: The source code editor used for database management and for execution of SQL queries. Currently the most popular Integrated Development Environment (IDE) on the market due to it's key features such as wide language support, high customisability and large range of extensions to support coding workflow.
* **Git and Github:** Git was the version control system I used to track my project and code and revert back to previous versions if something went wrong. To share my project and allow collaboration with peers I used Github.

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

*Image 2: Query 1 Output (top 10 results displayed).*

**Query Breakdown:**

In this query, I am querying from the job_postings_fact table, as this table contains the relevant information to answer the question such as the job title and yearly salary. Here, I chose to join the job_postings_fact table to the company_dim table using a left join, in order to to retrieve the name of the companies offering the role, whilst keeping all the rows from the job_postings_fact table. I have aliased the "name" column as "company_name", to show that the name column is coming from the company_dim table. When two columns are in different tables but share the same name, it's important to mentioned the table name and/or alias the columns so the reader knows which table each column is coming from.

In the WHERE clause, I chose to filter by Data Analyst roles only with the location set to "anywhere" (remote jobs), with the salary value not being a null. Finally, I ordered by the salary in descending order (highest to lowest) and limited the output to 10 rows.

**Insights:**
* **Broad Salary Range:** The top 10 paying Data Analyst roles range from $184,000 to $650,000 USD, indidicating a strong salary potential in the field.
* **Employer Diversity:** Top paying Data Analyst jobs span across various industries such as information technology (Meta), telecommunications (AT & T), Marketing/Social Media (Pinterest) and Health (UCLA Health). This portrays that top salaries are available across a range of different industries and aren't limited to a select few. 
* **Job Title Variation:** There are diverse job titles in the feild including Data Analyst, Principal Data Analyst, Associate Director and Director of Analytics, reflecting the various roles and levels within the field.

**Visualisation:**

The results of the query were exported as a CSV file from VS Studio Code, from there I visualised the results using Excel. To clarify, I avoided using the "$" dollar sign in the x-axis number labels as too many dollar signs may be distracting. Rather, I chose to mention (USD) in the title to inform that the data is in US Dollars. 

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

**Output:**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/df3d1b1f-355d-4cc4-b410-2db6693bc71e)

*Image 4: Query 2 Output (only the first 3 jobs displayed).*


**Query Breakdown:**

Using Query #1 I was able to retrieve the top 10 highest paying remote data analyst jobs. With Query #2, my aim was to explore the skills associated with these top paying jobs. In order to do this, I had to join the results of Query #1 to the skills_job_dim table which contains the skill id, then join the skills_job_dim table with the skills_dim table to retrieve the skill name. Rather than re-writing Query #1 and using a subquery, I chose to modify it into a CTE (top_paying_jobs) to shorten the code and improve readability. Query #1 was kept the same, as our criteria and conditions were unchanged, but I left only the columns which I felt were relevant in answering the question in the SELECT statement. 

To obtain the skills, I utilised inner joins in the main query to connect the top_paying_jobs CTE to the skills_job_dim table, and then connect the skills_job_dim table to the skills_dim table. 

Out of the top 10 highest paying remote data analyst jobs I found earlier, the top two jobs (Data Analyst at Mantys & Director of Analytics at Meta), did not have have skills associated with them, hence, these were omitted from the visualisation below. The visualisation showcases the skill count for only the 8 remote data analyst following the top two which we omitted.

**Visualisation:**

The results of Query #2 were also exported as a CSV file from VS Studio Code and a visusalisation was created using Excel.

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/0d699c22-1923-489c-8392-71784c9d993f)

*Image 5: Bar Graph for the count of skills for top 8 Data Analyst roles.*



**Insights:** 

For the top 8 highest paying remote Data Analyst jobs, after omitting the top two jobs, SQL is a leading skill is a required skill for all 8 roles.

Generally, a traditional data analyst toolkit comprises of tools such as SQL (to query databases), Python (for advanced analyses) or R (for advanced analyses/statistical analyses), Tableau (for dashboards and visualisations) and Excel. Therefore, it makes sense for the top skills to comprise of these skills as they're more traditional and foundational skills.

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

*Image 6: Query 3 Output (only the top 5 skills displayed).


**Query Breakdown:**

The aim of this query was to identify the most in-demand skills for data analysts, by focusing on all job postings, rather than the top paying job postings.

To do this, I had to calculate how many times a skill showed up in the job postings (count of skills). Much of the query was similar in structure to the main query in Query #2, however instead of the top_paying_jobs CTE, I had to utilise inner joins to connect the job_postings_fact table with the skills_job_dim table, which would then connect to the skills_dim table to retrieve the skill names linked to each job posting. 

The SELECT statement comprises of the skills column in order to retrieve the skill name, and the aggregate COUNT function in order to count how many times each skill appears in job postings. The filters in the WHERE clause remained the same, as we are still filtering by remote Data Analyst roles. 

The GROUP BY clause was used due to the COUNT function in the SELECT statement, which will group the count by each skill. Finally, I ordered by the count of skills in descending order (highest to lowest) and limited the output to 5, resulting in only the top 5 most in demand skills being displayed.

**Insights:**

With SQL and Excel being fundamental Data Analyst skills, it's no surprise that these skills are the most in demand. This emphasises the need for strong foundational skills in database querying and spreadsheets. Python, Tableau and Power Bi are next on the list, showcasing the importance of technical skills in advanced analyses and data visualisation. 


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

**Output:**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/ba1a43ac-e4b8-4222-b29b-6291eeef6cf2)


*Image 7: Query 4 Output (only the top 10 results displayed).*




**Query Breakdown:**

With this query, my aim was to calculate the average yearly salary per skill for Data Analyst roles. 

The structure of this query is almost identical to Query #3, however, instead of using the COUNT function, I have used the AVG function in the SELECT statement to get the average salary in job postings, rounded to 2 decimal places using the ROUND function. Once again I had to query the job_postings_fact table, joined to the skills_job_dim table and skills_dim table in order to connect the skills to each job posting.  

The filtering in the WHERE clause remains similar, as I am still interested in remote Data Analyst roles, however, this time I have included the IS NOT NULL operator to filter for roles with a salary value. Since I have used the AVG aggregation in the SELECT statement, a GROUP BY clause has also been used to group the average salaries by skill. Finally, the results will be limited to 25 rows, sorted in descending order (highest to lowest) by average salary.

**Insights:**

The top paying skills revolve around large scale data processing tools such as PySpark and Couchbase, machine learning tools such as DataRobot and Jupyter, Python libraries like Pandas and NumPy and cloud computing tools such as Elasticsearch and Bitbucket. This showcases the high value placed on skills involving big data technologies, predictive modelling and cloud analytics in the Data Analyst job market. 

## 5. Most optimal skills to learn

**Query:**

```sql
-- Finding most optimal skills (high demand and high pay)
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
LIMIT 20;


```

**Output**

![image](https://github.com/parvezs27/SQL_Data_Jobs_Analysis/assets/107979122/d1b8def4-1ad5-47d1-b854-1f6458c8307a)


*Image 8: Query 5 Output (top 20 results displayed).*



**Query Breakdown:**

This query aimed to identify "optimal" skills, that is, skills which are in high demand and are also associated with high average salaries for remote Data Analyst roles. Exploring these skills can help with targeting skills that offer job security (high demand) and financial benefits (high salaries).

This query could have been structured differently than above. One way would have been to assign a CTE for both Query #3 and Query #4, since we had already found the most in-demand skills and the average salary for skills. These CTE's could have been combined to produce the same output as above. However, doing it this way would have led to lengthy code and I found that the structure I utilised was more efficient and easier to read.

In the SELECT statement, I wanted to retrieve the skill id, the skill name, the average salary of each skill (rounded to 2 decimal places) and the COUNT of job id's, to count how often each skill appears in job postings. Then in the FROM clause, similar to the previous queries, I joined the job_postings_fact table with the skills_job_dim table, which was then joined with the skills_dim table using inner joins, allowing skills to be connected to each job posting. 

The filters in the WHERE clause remain the same as Query #1 and Query #4, as we're still interested in remote Data Analyst roles with no null values for the salary. However this time round, the HAVING clause has been used as I wanted to filter by the aggregated demand_count column, including only those skills that have appeared more than 10 times in job postings. I found that when I didn't filter for skills that showed more than 10 times across the job postings, I was left with low demand but high paying skills.

With the COUNT aggregation in the SELECT statement, I also had to use the GROUP BY clause and group by the skill id. Typically, when using the GROUP BY clause you would include all columns in the SELECT statement other than the column being aggregated, however, since I was grouping by a primary key, I didn't need to in this case. 

**Insights:**

Immediately programming languages such as Python and R stand out with high demand counts of 236 and 148 respectively. However, the average salaries for these skills sit lower than some of the other skills, suggesting that whilst proficiency in these programming languages is highly sought out, competency in these skills is more available than the more optimal skills higher up on the list.

Looking at the top 10 results, cloud and big data technologies such as Snowflake, Azure, AWS and Bigquery dominate with demand and high salaries. This isn't surprising as these technologies are rapidly growing in importance, with the cloud computing market expected to grow from $619 billion USD in 2023 to [$1,554 billion USD in 2030](https://www.grandviewresearch.com/industry-analysis/cloud-computing-industry/methodology). 

Business Intelligence and Visualisation tools such as Tableau and Looker show high demand counts of 230 and 49 respectively, suggesting the importance of these tools in business intelligence and driving strategic data driven business decisions. 

Finally, the demand for database technologies such as Oracle and NoSQL can be seen, with salaries ranging from $101,414 to $104,534, suggesting the importance of database management skills. 

# Conclusions and Recommendations:

**1. Top paying data analyst jobs:**

There are a variety of top paying remote Data Analyst roles all the way upto Director level, ranging across various industries such as Telecommunications, Marketing and Health. The top paying remote Data Analyst roles offer a broad range of salaries, all the way upto $650,000 USD. This indicates that job seekers have a variety of paths to choose from with scope for career and salary growth in Data Analytics. 

**2. Required skills for the top paying data analyst jobs**

The top paying Data Analyst jobs require proficiency in various skills with SQL being the top skill, followed by Python and Tableau. 

**3. Most in-demand skills for Data Analysts**

Not only is SQL the top skill for the top paying Data Analyst jobs, but it's also the most in-demand skills for Data Analyst jobs in general. 

**4. Skills associated with higher salaries**

The top 10 highest paying skills are dominated by Big Data (PySpark, Couchbase), Machine Learning (DataRobot, Jupyter) and Cloud Computing technologies (Elasticsearch), suggesting a higher value placed on specialised and niche skills. 

**5. Optimal skills**

If we look at the results from Query #5, the top optimal skills seem to comprise of Big Data, Cloud Computing and more specialised/niche skills. However, the most in-demand skills required for the top paying jobs seem to comprise of more traditional skills such as SQL, Python and Tableau. 

**Recommendations**

For those looking to enter into a Data Analyst role, a solid focus should be placed on the most  foundational skills, which are also the most in-demand skills such as SQL, Python and Tableau. With time as these foundational skills are developed and experience accumulates, gaining proficiency in specialised, in-demand technologies such as Big Data, Cloud Computing or Machine Learning, will help boost career opportunities and earning potential. 

**Learning and Best Practices**

Through this project I was able to improve my SQL skills and gain valuable insights into the Data job market. Specifically, I was able to focus on key SQL skills such as merging tables (joins), using CTE's and aggregate functions (count, average). Additionally, I learned how to utilise Git, Visual Studio Code and Github harmoniously, in order to track projects and push/pull changes to local and remote repositories on Github.

Some of the best practices I incoporated in this project:
- Using leading comma's to clearly define new columns in the SELECT statement and to help with readability and identification of missing comma's.
- Maintaining consistent code structure and alignment between clauses by using the tab key to improve readability of code and familiarity with code style. 
- Aliasing table names to shorten code and improve readability.
- Adding code comments to help others to understand the purpose of the code.
- Limiting results where needed and using CTE's to enhance query processing speed.
- Utilising simple, minimalistic bar charts to clearly and easily communicate insights with minimal cognitive load.
- Documenting key project information into a spreadsheet such as commencement date, completion dates, problems and how the problems were resolved. 

