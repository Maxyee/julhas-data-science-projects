-- Databricks notebook source
-- MAGIC %md
-- MAGIC #### TASK WITH HIVEQL

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Just change the `year` value from dropdown and run the code. It will generate all the required data for that year !

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.widgets.dropdown("YEAR", "2021", [str(x) for x in ['2019','2020','2021']])
-- MAGIC widget_year_value = dbutils.widgets.get("YEAR")
-- MAGIC string_year = widget_year_value

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm('/FileStore/tables/clinicaltrial', True)
-- MAGIC dbutils.fs.mkdirs('/FileStore/tables/clinicaltrial')
-- MAGIC dbutils.fs.mkdirs('/FileStore/tables/mesh')
-- MAGIC dbutils.fs.mkdirs('/FileStore/tables/pharma')
-- MAGIC dbutils.fs.cp('/FileStore/tables/clinicaltrial_'+string_year+'.csv', '/FileStore/tables/clinicaltrial')
-- MAGIC dbutils.fs.cp('/FileStore/tables/mesh.csv', '/FileStore/tables/mesh')
-- MAGIC dbutils.fs.cp('/FileStore/tables/pharma.csv', '/FileStore/tables/pharma')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 1

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS clinicaltrial (
  Id STRING,
  Sponsor STRING,
  Status STRING,
  Start STRING,
  Completion STRING,
  Type STRING,
  Submission STRING,
  Conditions STRING,
  Interventions STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LOCATION '/FileStore/tables/clinicaltrial';

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS clinic AS
SELECT *
FROM   clinicaltrial
WHERE  id != 'Id';

-- COMMAND ----------

SELECT DISTINCT COUNT(*) FROM clinic;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 2

-- COMMAND ----------

SELECT type,
       Count(type) AS count
FROM   clinic
GROUP  BY type
ORDER  BY count DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 3

-- COMMAND ----------

SELECT   condition,
         Count(type)                                                    AS count
FROM     clinic lateral view explode(split(conditions, ',')) conditions AS condition
WHERE    conditions != ''
GROUP BY condition
ORDER BY count DESC limit 5;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 4

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS mesh (
  term STRING,
  tree STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/FileStore/tables/mesh';

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS mesh_data AS
SELECT *
FROM   mesh
WHERE  term != 'term';

-- COMMAND ----------

DROP VIEW IF EXISTS conditions;

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS conditions AS
SELECT condition
FROM   clinic lateral VIEW explode(split(conditions, ',')) conditions AS condition;

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS conditions_tree AS
SELECT conditions.condition        AS condition,
       substr(mesh_data.tree, 1,3) AS tree
FROM   mesh_data
JOIN   conditions
ON     mesh_data.term = conditions.condition;

-- COMMAND ----------

SELECT tree,
       Count(tree) AS count
FROM   conditions_tree
GROUP  BY tree
ORDER  BY count DESC
LIMIT  10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 5

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS pharma (
  Company STRING,
  Parent_Company STRING,
  Penalty_Amount STRING,
  Subtraction_From_Penalty STRING,
  Penalty_Amount_Adjusted_For_Eliminating_Multiple_Counting STRING,
  Penalty_Year STRING,
  Penalty_Date STRING,
  Offense_Group STRING,
  Primary_Offense STRING,
  Secondary_Offense STRING,
  Description STRING,
  Level_of_Government STRING,
  Action_Type STRING,
  Agency STRING,
  Criminal STRING,
  Prosecution_Agreement STRING,
  Court STRING,
  Case_ID STRING,
  Private_Litigation_Case_Title STRING,
  Facility_State STRING,
  Lawsuit_Resolution STRING,
  City STRING,
  Address STRING,
  Zip STRING,
  NAICS_Code STRING,
  NAICS_Translation STRING,
  HQ_Country_of_Parent STRING,
  HQ_State_of_Parent STRING,
  Ownership_Structure STRING,
  Parent_Company_Stock_Ticker STRING,
  Major_Industry_of_Parent STRING,
  Specific_Industry_of_Parent STRING,
  Info_Source STRING,
  Notes STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/FileStore/tables/pharma';

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS parent_company
AS
  SELECT Replace(parent_company, '"', '') AS Parent_Company
  FROM   pharma;

-- COMMAND ----------

DROP VIEW IF EXISTS clinical_all_company;

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS clinical_all_company AS
SELECT          clinic_comp.sponsor       AS sponsor,
                parent_com.parent_company AS parent_company
FROM            clinic               AS clinic_comp
LEFT OUTER JOIN parent_company            AS parent_com
ON              clinic_comp.sponsor = parent_com.parent_company;

-- COMMAND ----------

SELECT sponsor,
       Count(sponsor) AS count
FROM   clinical_all_company
WHERE  parent_company IS NULL
GROUP  BY sponsor
ORDER  BY count DESC
LIMIT  10; 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Problem 6

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS completion_status AS
SELECT status,
       substr(completion, 1,3) AS completion_month,
       substr(completion,4)    AS completion_year
FROM   clinic
WHERE  status = 'Completed';

-- COMMAND ----------

CREATE VIEW IF NOT EXISTS completion_story AS
SELECT completion_month, completion_year,
       CASE completion_month
         WHEN 'Jan' THEN 1
         WHEN 'Feb' THEN 2
         WHEN 'Mar' THEN 3
         WHEN 'Apr' THEN 4
         WHEN 'May' THEN 5
         WHEN 'Jun' THEN 6
         WHEN 'Jul' THEN 7
         WHEN 'Aug' THEN 8
         WHEN 'Sep' THEN 9
         WHEN 'Oct' THEN 10
         WHEN 'Nov' THEN 11
         WHEN 'Dec' THEN 12
       END                     AS MonthNum,
       Count(completion_month) AS count
FROM   completion_status
GROUP  BY completion_month, completion_year
ORDER  BY monthnum ASC;

-- COMMAND ----------

SELECT completion_month, count FROM completion_story WHERE completion_year LIKE '%$YEAR%';
