# Databricks notebook source
import dlt
import pyspark.sql.functions as F
import pyspark.sql.types as T

# COMMAND ----------

bucket_name = spark.conf.get("s3_bucket_name")
json_path = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json"
path_clickstream_raw = f"s3://{bucket_name}/clickstream_raw_delta"
path_clickstream_prepared = f"s3://{bucket_name}/clickstream_prepared"
path_top_spark_referrers = f"s3://{bucket_name}/top_spark_referrers"

# COMMAND ----------

@dlt.table(
  comment="The raw wikipedia clickstream dataset, ingested from /databricks-datasets.",
  path=path_clickstream_raw,
)
def clickstream_raw():
  return (spark.read.json(json_path))

# COMMAND ----------

@dlt.table(
  comment="Wikipedia clickstream data cleaned and prepared for analysis.",
  path=path_clickstream_prepared,
)
@dlt.expect("valid_current_page_title", "current_page_title IS NOT NULL")
@dlt.expect_or_fail("valid_count", "click_count > 0")
def clickstream_prepared():
  return (
    dlt.read("clickstream_raw")
      .withColumn("click_count", F.expr("CAST(n AS INT)"))
      .withColumnRenamed("curr_title", "current_page_title")
      .withColumnRenamed("prev_title", "previous_page_title")
      .select("current_page_title", "click_count", "previous_page_title")
  )

# COMMAND ----------

@dlt.table(
  comment="A table containing the top pages linking to the Apache Spark page.",
  path=path_top_spark_referrers,
)
def top_spark_referrers():
  return (
    dlt.read("clickstream_prepared")
      .filter(F.expr("current_page_title == 'Apache_Spark'"))
      .withColumnRenamed("previous_page_title", "referrer")
      .sort(F.desc("click_count"))
      .select("referrer", "click_count")
      .limit(10)
  )
