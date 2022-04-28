# Databricks notebook source
# MAGIC %md
# MAGIC ### Number 1

# COMMAND ----------

dataDF = spark.read.options(delimiter=',').csv('dbfs:/databricks-datasets/COVID/CORD-19/2020-03-27/metadata.csv', header=True)
dataDF.show(truncate=False)

# COMMAND ----------

dataDF.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 2

# COMMAND ----------

dataRDD = dataDF.rdd
dataRDD.take(5)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 3

# COMMAND ----------

pairRDD = dataRDD.map(lambda x: (x[0], x[8]))
pairRDD.take(5)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 4

# COMMAND ----------

pairRDD = pairRDD.filter(lambda x: x[1] != None)

# COMMAND ----------

wordPairRDD = pairRDD.map(lambda j: (j[0],j[1].split(' ')))
wordPairRDD.take(5)

# COMMAND ----------

dbutils.fs.ls('/FileStore/tables')

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 5

# COMMAND ----------

positiveWordsDF = spark.read.csv('dbfs:/FileStore/tables/positive_words.csv')
positiveWordsDF.show(truncate=False)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 6

# COMMAND ----------

negativeWordsDF = spark.read.csv('dbfs:/FileStore/tables/negative_words.csv')
negativeWordsDF.show(truncate=False)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 7

# COMMAND ----------

positive_words_set = set(positiveWordsDF.select('_c0').rdd.flatMap(lambda x : x).collect())
positive_words_set

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 8

# COMMAND ----------

negative_words_set = set(negativeWordsDF.select('_c0').rdd.flatMap(lambda x : x).collect())
negative_words_set

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 9

# COMMAND ----------

list_of_words = wordPairRDD.flatMap(lambda x: x[1])
list_of_words.take(5)

# COMMAND ----------

posNegPairRDD = wordPairRDD.map(lambda x: (x[0], len(list(set(x[1]) & positive_words_set)), len(list(set(x[1]) & negative_words_set))))

# COMMAND ----------

posNegPairRDD.take(10)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Number 10

# COMMAND ----------

positiveSortRDD = posNegPairRDD.sortBy(lambda z: z[1], ascending=False)

# COMMAND ----------

positiveSortRDD.take(5)

# COMMAND ----------

negativeSortRDD = posNegPairRDD.sortBy(lambda z: z[2], ascending=False)

# COMMAND ----------

negativeSortRDD.take(5)

# COMMAND ----------

compairRDD = positiveSortRDD.first() == negativeSortRDD.first()
compairRDD

# COMMAND ----------


