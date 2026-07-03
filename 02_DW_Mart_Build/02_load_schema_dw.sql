-- Step 2: DW - Load data from csv file into tables

SELECT '===loading company_dim Table===' AS info;

INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true,
     HEADER=true,
      max_line_size=100_000_000,
      null_padding=true,
      ignore_errors=true
     );

SELECT '===loading skills_dim Table===' AS info;

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=true,
    HEADER=true)
WHERE skills IS NOT NULL;

SELECT '===loading job_postings_fact Table===' AS info;

INSERT INTO job_postings_fact (
     job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT  job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=true,
     HEADER=true,
     nullstr = ['N/A', '', 'NULL', 'missing'],
     ignore_errors=true,
     max_line_size = 100_000_000,
     null_padding = true
    );

SELECT '===loading skills_job_dim Table===' AS info;

INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=true,
     HEADER=true)
WHERE job_id IN (SELECT job_id FROM job_postings_fact);
