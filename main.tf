# DATA
data "databricks_current_user" "me" {}

# RESOURCES

## Notebook
resource "databricks_notebook" "dlt_pipeline_notebook" {
  source = "${path.module}/src/dlt_pipeline_notebook.py"
  path   = "${data.databricks_current_user.me.home}/examples/terraform-dlt-${var.cluster_environment_type}"
  format = "SOURCE"
}

## DLT pipeline
resource "databricks_pipeline" "this" {
  name    = "Terraform DLT Example - ${var.cluster_environment_type}"
  storage = var.dlt_pipeline_storage_path
  target  = var.dlt_databricks_database
  configuration = {
    s3_bucket_name = var.s3_bucket_name
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
      CostCenter      = var.cluster_cost_center
      EnvironmentType = var.cluster_environment_type
      Service         = var.cluster_service
    }
  }

  cluster {
    label       = "maintenance"
    num_workers = 1
    aws_attributes {
      instance_profile_arn = var.cluster_instance_profile_arn
    }
    custom_tags = {
      CostCenter      = var.cluster_cost_center
      EnvironmentType = var.cluster_environment_type
      Service         = var.cluster_service
    }
  }

  library {
    notebook {
      path = databricks_notebook.dlt_pipeline_notebook.id
    }
  }

  filters {}

  edition = "ADVANCED"
  development = true
  continuous = false
}

resource "databricks_job" "this" {
  name = "Terraform DLT Example - job"
  pipeline_task {
    pipeline_id = databricks_pipeline.this.id
  }

  schedule {
    quartz_cron_expression = "0 0 3 ? * Mon,Wed,Fri"
    timezone_id            = "Europe/Stockholm"
  }

  email_notifications {
    on_failure = [data.databricks_current_user.me.user_name]
  }
}
