# Introduction
📊 Dive into the Netherland data job market!

Focusing on entry-level data roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and where 📈 high demand meets high salary in data analytics.

🔎 Looking for the SQL queries? Check them out here: [project SQL queries](/project_sql/)
# Background
While taking Luke Barousse [SQL course](https://github.com/lukebarousse/SQL_Project_Data_Job_Analysis) I developed this simple project driven by a quest to navigate the Dutch data job market more effectively. I decided to change the objective of the exercise compared to Luke's since I am planning to relocate to the Netherlands and I'd like to pinpoint top-paid and in-demand skills and streamlining others work to find optimal jobs.

Data hails from my Luke's SQL Course. It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the low-paying data analyst jobs in the Netherlands?
2. What skills are required for these jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **PostgreSQL admin console:** I used the admin console on my laptop to check and compare runtimes between different script iteration in order to optimize the queries
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on the dutch market. This query highlights the low paying opportunities in the field.

```sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date:: date,--show as date only
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
```
Here's the breakdown of the data jobs in 2023 between Amsterdam & Utrecht:
- **Good salary for entry level positions:** Low 10 paying data analyst roles span from $53,000 to $111,000, indicating good salary potential for someone fresh in the field.
- **Similar Employers:** The lowest 10 jobs are offered by 7 companies.
- **Job Title Variety:** There's a high diversity in job titles, from Junior Data Analyst to Master Data Analyst, reflecting varied roles and specializations within data analytics.

<!-- ![Top Paying Roles](assets/1_top_paying_roles.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results* -->
### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for low-compensation roles.
```sql
WITH low_pay_job AS (
    SELECT	
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date:: date,--show as date only
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL & Python** are leading with a count of 4.
- **Excel** follows closely with a count of 3.
- **PowerBi** is also highly sought after, with a count of 2.

<!-- ![Top Paying Skills](assets/2_top_paying_roles_skills.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results* -->
### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Netherlands'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Python** remain fundamental, emphasizing the need for strong foundational skills in data processing and manipulation.
- **Excel**, **PowerBi** and **R**, are also essential, pointing towards the increasing importance of data storytelling and technical skills.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 2002         |
| Python   | 1571         |
| Excel    | 839          |
| Power BI | 764          |
| R        | 738          |

*Table of the demand for the top 5 skills in data analyst job postings*
### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which are the salaries for the most recurring skills.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Netherlands' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY COUNT(job_postings_fact.job_id) DESC
LIMIT 10;
```
Here's a breakdown of the results for top requested skills for Data Analysts:
- **High demand for Data Extraction and Manipulation skills:** The most recurrent skills by mention are SQL and Python, followed by R and Excel.

- **Low interest for Data Visualization skills:** Visualization tools are not deemed as important in these entry level job advertisments.

- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools like pyspark underscores compared to other skills in entry level position

- **Highest paying job:** These are related to cloud skills and data visualization, hence showing that aim to learn these skills early on might yield better salary outcome in the short term. 

| Skills        | Skill count | Average Salary ($) |
|---------------|-------------|-------------------:|
| SQL           | 10          |  98,907            |
| Python        | 10          |  89,921            |
| R             | 7           |  99,956            |
| Excel         | 7           |  85,371            |
| Tableu        | 3           | 106,959            |
| Sap           | 3           | 123,725            |
| Go            | 3           | 103,896            |
| Looker        | 3           | 103,826            |
| Power BI      | 3           |  86,033            |
| Pyspark       | 2           | 111,189            |

*Table of the average salary for the top 10 requested skills for data analysts*
### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Netherlands' AND
    salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 15;
```

| Skill id | Skills    | Skill count  | avg salary ($) |
|----------|-----------|--------------|---------------:|
| 74       | azure     | 1            | 177,283        |
| 92       | spark     | 1            | 177,283        |
| 2        | nosql     | 1            | 177,283        |
| 76       | aws       | 1            | 177,283        |
| 3        | scala     | 1            | 147,500        |
| 97       | hadoop    | 2            | 144,243        |
| 189      | sap       | 3            | 123,725        |
| 22       | vba       | 1            | 111,202        |
| 96       | airflow   | 1            | 111,202        |
| 95       | pyspark   | 2            | 111,189        |
| 188      | word      | 1            | 111,175        |
| 198      | outlook   | 2            | 108,088        |
| 182      | tableau   | 3            | 106,959        |
| 196      | powerpoint| 1            | 105,000        |
| 202      | ms access | 1            | 105,000        |


*Table of the most optimal skills for data analyst sorted by salary in the Netherlands*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **Cloud Technologies:** Azure and AWS are highly sought after with demand counts of 1 each and a leading average salary of $177,283, indicating the significant value placed on cloud expertise in the industry.
- **Big Data Tools:** Skills in Spark, Hadoop, and PySpark show notable demand with average salaries of $177,283 for Spark and $144,243 for Hadoop, reflecting the critical role of big data technologies in managing and analyzing large datasets.
- **Business Intelligence and Analytics Tools:** Tableau stands out with the highest demand count of 3 and an average salary of $106,959, underscoring the importance of data visualization and business intelligence in driving strategic decisions.
- **Office and Productivity Tools:** Skills in SAP, Word, Outlook, and PowerPoint are in demand with varying average salaries (e.g., SAP at $123,725 and Outlook at $108,088), highlighting the essential role of these tools in everyday business operations and communication.

# What I Learned


Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **🧑‍💻 Code planning :** Understood the impact of complex queries like CTE on the code and tested other solutions to improve efficiency.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusions
This project helped me understand the basis of SQL and provided valuable insights into the data analyst job market in the Netherland. The findings from the analysis serve as a guide to prioritize skill development and job search efforts as well as have an idea of which financial possibilities there are in this industry.