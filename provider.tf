terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "bigdata"
  region = "eu-west-1"
}

provider "databricks" {
  profile = var.databricks_connection_profile
}
