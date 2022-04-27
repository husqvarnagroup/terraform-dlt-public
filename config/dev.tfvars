databricks_connection_profile = ""

databricks_user_name = "miles.hopper@husqvarnagroup.com"

cluster_environment_type = "dev"

cluster_instance_type = "i3.xlarge"

cluster_instance_profile_arn = "arn:aws:iam::051499628644:instance-profile/BigData-live-databricks-iam-BigDataStack-P2K744AU3KM0-DatabricksBigDataInstanceProfile-5ZI3THDU8Y4"

s3_backend_bucket = "husqvarna-datalake-dev" # Recommended that bucket version control is enabled

s3_backend_key = "analytics/usr/miles.hopper/terraform-dlt/configuration/terraform-state"

s3_backend_region = "eu-west-1"

s3_backend_profile = "BigData"

s3_trusted_prefix = "/mnt/husqvarna-datalake-dev/analytics/usr/miles.hopper/terraform-dlt/trusted"