-- Employee_ID	Department	Gender	Age	Education_Level	Job_Role	Monthly_Income	Years_At_Company	
-- Years_In_Current_Role	Job_Satisfaction	Performance_Rating	Work_Life_Balance	Training_Hours_Last_Year
-- 	Last_Promotion_Years_Ago	Distance_From_Home	Overtime	Attrition	Marital_Status	Number_Of_Companies_Worked	
--  Stock_Option_Level

Create database source;
use source;
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- creating table for the whole data
 
 CREATE TABLE source (
    employee_id INT,
    department VARCHAR(20),
    gender VARCHAR(15),
    age INT,
    education_level VARCHAR(20),
    job_role VARCHAR(30),
    monthly_income INT,
    years_at_company INT,
    years_in_current_role INT,
    job_satisfaction INT,
    performance_rating INT,
    work_life_balance INT,
    training_hours_last_year INT,
    last_promotion_years_ago INT,
    distance_from_home INT,
    overtime VARCHAR(5),
    attrition VARCHAR(5),
    maritial_status VARCHAR(10),
    number_of_companies_worked INT,
    stock_option_level INT
);
 
 select * from source;
 -- verifying there is no duplicate employee id in the database so it can be used as a primary key 
 SELECT source.employee_id, COUNT(*) AS cnt
FROM source
GROUP BY source.employee_id
HAVING COUNT(*) > 1;

 
 -- creating tables from the main source file ( star schema)

-- departments table 

create table departments ( department_id int auto_increment primary key  ,department varchar(25) unique );
insert into departments(department) select distinct source.department  from source;
select  * from departments;

-- job role table 

create table job_roles (job_role_id int auto_increment primary key , job_role_name varchar(30) unique);
insert into job_roles (job_role_name) select distinct source.job_role from source;
select * from job_roles;

-- employees table 

CREATE TABLE employees AS
SELECT
    source.employee_id,
    departments.department_id,
    job_roles.job_role_id,
    source.age,
    source.gender,
    source.education_level,
    source.maritial_status AS marital_status,
    source.years_at_company,
    source.years_in_current_role,
    source.last_promotion_years_ago,
    source.distance_from_home,
    source.number_of_companies_worked,
    source.overtime,
    source.attrition
FROM source
JOIN departments ON departments.department = source.department
JOIN job_roles ON job_roles.job_role_name = source.job_role;

select * from employees;

alter table employees
		add primary key( employee_id),
        add foreign key(department_id) references departments(department_id),
        add foreign key (job_role_id) references job_roles(job_role_id);
        
	desc employees;
    
-- performance table
create table performance_scores as select 
employees.employee_id,
source.job_satisfaction,
source.performance_rating,
source.work_life_balance 
from source 
join employees on employees.employee_id= source.employee_id
;

alter table performance_scores
add foreign key (employee_id) references employees(employee_id);

alter table performance_scores
add primary key(employee_id);

select * from performance_scores;

-- compensation table 
create table compensation as select 
employees.employee_id,
source.monthly_income,
source.stock_option_level,
source.training_hours_last_year
from source
join employees on employees.employee_id = source.employee_id;

alter table compensation 
add primary key(employee_id),
add foreign key(employee_id) references employees(employee_id);

select * from compensation;
desc compensation;

-- Table Built ------------------------------------------------------------------------------------------------------------------------

-- DATA QUALITY NOTE: Import via MySQL Workbench's Table Data Import Wizard resulted in 
-- 2541 of 3400 source rows loading successfully (wizard silently skips rows on parsing 
-- issues rather than erroring). Verified attrition rate (50.8%) and department distribution 
-- remained consistent with the full dataset before proceeding — see README for details.