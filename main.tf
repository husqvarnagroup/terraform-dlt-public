# VARIABLES

variable "databricks_connection_profile" {
  description = "The name of the Databricks connection profile to use."
  type        = string
}

variable "databricks_user_name" {
  description = "The email address of the user's Databricks account"
  type = string
}

variable "cluster_environment_type" {
  description = "Cluster environment type"
  type = string
}

variable "cluster_instance_type" {
  description = "Cluster instance type"
  type        = string
}

variable "cluster_instance_profile_arn" {
  description = "The cluster instance profile arn"
  type = string
}


variable "s3_trusted_prefix" {
  description = "The DLT Pipeline S3 prefix for Trusted Data"
  type = string
}

# PROVIDER

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    databricks = {
      source = "databrickslabs/databricks"
    }
  }

  backend "s3" {
    bucket  = "husqvarna-datalake"
    key     = "analytics/usr/miles.hopper/terraform-dlt/configuration/terraform-state"
    region  = "eu-west-1"
    profile = "BigData"
  }
}

provider "databricks" {
  profile = var.databricks_connection_profile
}

# DATA

data "databricks_user" "me" {
  user_name = var.databricks_user_name
}

# RESOURCES

## Notebook
resource "databricks_notebook" "dlt_pipeline_notebook" {
  source = "${path.module}/src/dlt_pipeline_notebook.py"
  path   = "${data.databricks_user.me.home}/examples/terraform-dlt"
  format = "SOURCE"
}

## DLT pipeline
resource "databricks_pipeline" "this" {
  name    = "Terraform DLT Example - ${var.cluster_environment_type}"
  storage = "/mnt/husqvarna-datalake-dev/analytics/usr/miles.hopper/processing/first-pipeline-${var.cluster_environment_type}"
  target  = "example-database-${var.cluster_environment_type}"
  configuration = {
    s3_trusted_prefix = var.s3_trusted_prefix
  }

  cluster {
    label               = "default"
    num_workers         = 2
    node_type_id        = var.cluster_instance_type
    driver_node_type_id = var.cluster_instance_type
    aws_attributes {
      instance_profile_arn = var.cluster_instance_profile_arn
    }
    custom_tags = {
      CostCenter      = "bigdata"
      EnvironmentType = var.cluster_environment_type
      Service         = "bigdata"
      cluster_type    = "default"
    }
  }

  cluster {
    label       = "maintenance"
    num_workers = 1
    aws_attributes {
      instance_profile_arn = var.cluster_instance_profile_arn
    }
    custom_tags = {
      CostCenter      = "bigdata"
      EnvironmentType = var.cluster_environment_type
      Service         = "bigdata"
      cluster_type    = "maintenance"
    }
  }

  library {
    notebook {
      path = databricks_notebook.dlt_pipeline_notebook.id
    }
  }

  filters {}

  continuous = false
  # development = true
  # edition = core
}