# VARIABLES

variable "databricks_connection_profile" {
  description = "The name of the Databricks connection profile to use."
  type        = string
}

variable "dlt_pipeline_storage_path" {
  description = "The full S3 path to store the Delta Live Tables pipeline metadata"
  type = string
}

variable "dlt_databricks_database" {
  description = "The databricks hive database used to store the Delta Live Tables pipeline Tables"
  type = string
}

variable "cluster_instance_type" {
  description = "Cluster instance type"
  type        = string
}

variable "cluster_instance_profile_arn" {
  description = "The cluster instance profile arn that provide S3 access to Databricks cluster"
  type = string
}

variable "cluster_cost_center" {
  description = "The cluster CostCenter tag"
  type = string
}

variable "cluster_environment_type" {
  description = "Cluster EnvironmentType tag"
  type = string
}

variable "cluster_service" {
  description = "The cluster Service tag"
  type = string
}

variable "s3_bucket_name" {
  description = "The bucket name that contains the data"
  type = string
}
