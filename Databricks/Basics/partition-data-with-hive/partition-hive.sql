-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### Partition data in Hive

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Checking that the accounts file are ready or not.

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.ls('/FileStore/accounts')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number (1) 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Creating a Hive table using SQL notebook cell `account_hive`

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS accounts_hive (
  acct_num INT,
  acct_created TIMESTAMP,
  last_order TIMESTAMP,
  first_name STRING,
  last_name STRING,
  address STRING,
  city STRING,
  state STRING,
  zipcode STRING,
  phone_number STRING,
  last_click TIMESTAMP,
  last_logout TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/FileStore/accounts';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Checking hive-table is there or not?

-- COMMAND ----------

SHOW TABLES;

-- COMMAND ----------

SELECT * FROM accounts_hive;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number (2) 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC creating new empty table called `accounts_with_areacode`

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS accounts_with_areacode (
  acct_num INT,
  first_name STRING,
  last_name STRING,
  areacode STRING,
  phone_number STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/FileStore/accounts_with_areacode';

-- COMMAND ----------

DESCRIBE accounts_with_areacode;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(3) 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC overwriting table `accounts_with_areacode`

-- COMMAND ----------

INSERT OVERWRITE TABLE accounts_with_areacode
SELECT acct_num,first_name,last_name,LEFT(phone_number,3) as areacode,phone_number FROM accounts_hive;


-- COMMAND ----------

SELECT * FROM accounts_with_areacode;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(4) 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC creating a new table in hive called `accounts_by_areacode`

-- COMMAND ----------

CREATE EXTERNAL TABLE IF NOT EXISTS accounts_by_areacode (
  acct_num INT,
  first_name STRING,
  last_name STRING,
  phone_number STRING 
)
PARTITIONED BY (areacode STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/FileStore/accounts_by_areacode';

-- COMMAND ----------

DESCRIBE accounts_by_areacode;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(5)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC switching strict mode `off` dynamic partitioning.

-- COMMAND ----------

-- MAGIC %python
-- MAGIC from pyspark import HiveContext
-- MAGIC sc = spark.sparkContext
-- MAGIC hiveContext = HiveContext(spark.sparkContext)
-- MAGIC hiveContext.setConf("hive.exec.dynamic.partition.mode","nonstrict")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(6)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Overwriting table `accounts_by_areacode` with partition `areacode`

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.ls("/tmp")

-- COMMAND ----------

INSERT OVERWRITE TABLE accounts_by_areacode PARTITION(areacode)
SELECT acct_num, first_name, last_name, phone_number, areacode FROM accounts_with_areacode;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(7)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Testing overwriting table `accounts_by_areacode` data.

-- COMMAND ----------

SELECT * FROM accounts_by_areacode LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number(8)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC `dbutils.fs.ls` command to confirm that the `accounts_by_areacode` directory contains the partition directories

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.ls('FileStore/accounts_by_areacode/')

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Number (9)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC prints the number of files in the `accounts_by_areacode` directory using python

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dir= 'FileStore/accounts_by_areacode'
-- MAGIC number_files = len(dir)
-- MAGIC print(number_files)

-- COMMAND ----------


