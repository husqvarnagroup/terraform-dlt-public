terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
  # Where to store the Terraform state file
  # This can be stored in a S3 bucket. This allows multi user deployment and deployment pipelines via Azure Devops
  backend "s3" {
    bucket  = "<BUCKET NAME>"
    key     = "terraform/state_file" # S3 PREFIX
    region  = "eu-west-1" # REGION
    profile = "<PROFILE NAME>" # Profile for accessing AWS account if running locally
  }
}

provider "databricks" {
  # https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication
  # USE the profile from your .databrickscfg file or just the host+token config
  profile = var.databricks_connection_profile

  # host = "https://ABC123.cloud.databricks.com/" # Workspace URL
  # token = environment variable DATABRICKS_TOKEN # TOKEN
}
