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

variable "s3_backend_bucket" {
  description = "The S3 Bucket used to store the Terraform backend"  # Recommended that bucket version control is enabled
  type = string
} 

variable "s3_backend_key" {
  description = "The S3 Key used to store the Terraform backend"
  type = string  
}

variable "s3_backend_region" {
  description = "The S3 AWS region used to store the Terraform backend"
  type = string  
}

variable "s3_backend_profile" {
  description = "The S3 profile used to store the Terraform backend"
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
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_key
    region  = var.s3_backend_region
    profile = var.s3_backend_profile
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
  path   = "${data.databricks_user.me.repos}/examples/terraform-dlt"
  format = "SOURCE"
}

## DLT pipeline
resource "databricks_pipeline" "this" {
  name    = "Terraform DLT Example - ${var.cluster_environment_type}"
  storage = "/mnt/husqvarna-datalake-dev/analytics/usr/miles.hopper/processing/first-pipeline-${var.cluster_environment_type}"
  target  = "example-database-${var.cluster_environment_type}"

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
      path = databricks_notebook.dlt_manufacturing.id
    }
  }

  filters {}

  continuous = false
}