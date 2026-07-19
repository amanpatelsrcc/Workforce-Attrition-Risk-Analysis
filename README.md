# Workforce Attrition Risk Dashboard

An HR analytics project built with SQL and Power BI, using an employee dataset to figure out where attrition risk actually shows up, and where the usual assumed causes just don't hold up once you test them.

## Short Description

This project looks at employee level HR data to check whether the standard attrition drivers (overtime, satisfaction, tenure, pay, etc.) actually explain who leaves, and to find out where attrition risk is genuinely concentrated. It's a self directed portfolio project, and the second in a series after a retail profitability dashboard I built earlier.

## Tech Stack

- **MySQL** – schema design, data cleaning, and building the core relational tables (employees, departments, job_roles, compensation, performance_scores)
- **Power BI Desktop** – dashboard build, visuals, and all the bucketing/segmentation logic
- **DAX** – calculated columns (tenure, income, and promotion gap buckets, department role combined labels, sort order helpers) plus measures for attrition rate, headcount, and averages
- **File formats** – `.sql` for the database script, `.pbix` for the Power BI file

**A note on how the work was split:** SQL only handles schema, cleaning, and the core tables here. Any bucketing (tenure, income, promotion gap) and the combined department-role labels are built as DAX columns inside Power BI instead. This was intentional — it keeps Power BI's data model doing the analytical work it's meant for, rather than exporting narrow pre-aggregated tables out of SQL first.

## Data Source

Employee level HR dataset from Kaggle, 3,400 records covering demographics, compensation, tenure, performance, and attrition. During import into MySQL, only 2,541 of the 3,400 rows actually made it into the database because of a row-skipping issue with Workbench's Import Wizard. Before moving forward, I checked whether this dropped subset was biased in any way — department distribution and overall attrition rate in the smaller set both matched the full file closely, so I treated it as reliable and continued. More on this in the Data Quality Note below.

## Features / Highlights

### Business Problem
It's easy to assume attrition is driven by the obvious stuff like pay, overtime, or satisfaction scores, and act on those assumptions without ever really testing them. This project does the opposite — every commonly assumed driver gets tested individually before any story gets built around it, and a pattern only gets reported once it's actually shown up in the data.

Questions this project set out to answer:
- Do the usual suspects (overtime, satisfaction, work-life balance, time since promotion) actually predict attrition here?
- Does compensation (income, stock options, training investment) make any real difference?
- Is attrition concentrated in specific departments, roles, or more specifically, specific department and role combinations?

### Goal of the Dashboard
To build an honest diagnostic tool that:
- Tests standard HR attrition drivers instead of assuming they apply
- Clearly reports when a factor shows no real relationship with attrition, instead of forcing a narrative
- Identifies the one place a real, actionable pattern actually shows up — the department by role interaction
- Gives HR teams a specific, evidence-based place to focus retention efforts

### Walkthrough of Key Visuals

**Overview Page**
- KPI cards: Total Employees (3K), Attrition Rate (50.8%), Average Tenure (16.01 yrs), Average Monthly Income (5.15K)
- Attrition by Job Role and Attrition by Department (bar charts) – fairly narrow spread on both, no standout category
- Attrition by Gender (donut) and Attrition by Education (treemap) – rounds out the compositional picture

**Attrition Drivers Page**
- Attrition by Overtime (donut)
- Job Satisfaction and Work-Life Balance shown together on one area chart, sharing a 1–5 score axis
- Attrition by Years Since Last Promotion (bucketed bar chart)
- Finding: none of these commonly expected drivers show a meaningful standalone relationship with attrition – rates stay in a narrow 49–55% band across every segment tested

**Compensation & Tenure Page**
- Attrition by Income Bracket, Stock Option Level, Training Hours, and Tenure Bucket
- Finding: same story here – compensation and tenure-related factors show no measurable relationship with attrition on their own, holding steady in a 47–53% band

**Department & Role Page**
- Department × Role heatmap matrix
- Ranked Highest Risk and Lowest Risk Combination charts
- Drillable department-to-role summary table
- Finding: this is where a real signal finally shows up. Sales Executives (60.6%) and HR Team Leads (58.8%) run well above average, while IT Managers (38.4%) run well below it – a 22-point spread, far wider than anything found testing single variables alone. The same role can also swing a lot depending on department: Executive attrition ranges from 44.7% in Marketing up to 60.6% in Sales

### Business Impact & Insight
- **The core finding:** attrition in this dataset isn't explained by any single employee-level factor. Not overtime, not satisfaction, not pay, not tenure. Every individual variable tested stayed within a narrow 47–55% band. What actually explains it is the specific combination of department and role, where the spread widens to 38.4%–60.6%, a 22-point gap.
- **Practical takeaway:** retention efforts are better aimed at Sales Executives (104 employees, 60.6% attrition) and HR Team Leads (119 employees, 58.8% attrition), both well above the company-wide average of 50.8%, rather than broad changes like general pay raises or overtime caps, which this data suggests wouldn't move the needle much on their own. By contrast, IT Managers (86 employees) sit at just 38.4%, a useful benchmark for what "healthy" looks like elsewhere in the org.
- **Analytical takeaway:** this project deliberately tested and reported null results across ten-plus variables instead of forcing a narrative onto the data. The honest "no driver found" conclusion on three of the four pages, each backed by the actual rate ranges above, is itself a real finding, not a shortcoming.

## Data Quality Note

While importing the source CSV into MySQL through Workbench's Table Data Import Wizard, only 2,541 of the expected 3,400 rows loaded. The wizard tends to silently skip rows when it hits parsing issues instead of throwing an error. Rather than treat this as a dead end, I validated the resulting subset by comparing department distribution and overall attrition rate against the full 3,400-row file. Both matched closely, which suggested the row loss was random rather than tied to any particular group. Every finding in this dashboard is built on that validated 2,541-row working set.

Worth noting separately: attrition rate stayed within a tight 47–55% band across almost every single variable tested, department, overtime, satisfaction, work-life balance, tenure, income, stock options, and training hours all included. Real-world HR data is rarely this uniform. It's likely this dataset was generated without strong correlations built in between attrition and most individual features, rather than reflecting genuine workplace dynamics. The one exception, the department-role interaction on the final page, is the one place a pattern held up regardless.

## Files in this Repo
- `Workforce_attriton_risk_analysis.sql` – full schema, data cleaning, and core relational table creation
- `workforce_attrition_risk_analysis.pbix` – final dashboard with all interactive visuals and DAX logic
- `workforce_attrition_risk_analysis.pbit` - final dashboard template 
- `workforce_attrition_risk_analysis.pdf` - final dashboard in a PDF format
## Screenshots
<img width="1219" height="682" alt="image" src="https://github.com/user-attachments/assets/e737d7ff-1f25-4c41-a419-3b1d8edad057" />
<img width="1229" height="684" alt="image" src="https://github.com/user-attachments/assets/193b14ea-dd6e-4407-82b8-343d4f6de80f" />
<img width="1227" height="689" alt="image" src="https://github.com/user-attachments/assets/44fdb777-b36f-48c5-960c-d5ac43809c40" />
<img width="1222" height="690" alt="image" src="https://github.com/user-attachments/assets/f0373618-bcc2-4594-b037-e69e1e70ff39" />


