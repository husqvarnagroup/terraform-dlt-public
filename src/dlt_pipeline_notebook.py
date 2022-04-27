import dlt
import pyspark.sql.functions as F
import pyspark.sql.types as T

s3_trusted_prefix = spark.conf.get("s3_trusted_prefix")
s3_trusted_prefix_clickstream_raw = s3_trusted_prefix + "/clickstream_raw"
s3_trusted_prefix_clickstream_prepared = s3_trusted_prefix + "/clickstream_prepared"
s3_trusted_prefix_top_spark_referrers = s3_trusted_prefix + "/ctop_spark_referrers"

json_path = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json"
@dlt.table(
  comment="The raw wikipedia clickstream dataset, ingested from /databricks-datasets.",
  path=s3_trusted_prefix_clickstream_raw,
)
def clickstream_raw():
  return (spark.read.json(json_path))


@dlt.table(
  comment="Wikipedia clickstream data cleaned and prepared for analysis.",
  path=s3_trusted_prefix_clickstream_prepared,
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


@dlt.table(
  comment="A table containing the top pages linking to the Apache Spark page.",
  path=s3_trusted_prefix_top_spark_referrers,
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