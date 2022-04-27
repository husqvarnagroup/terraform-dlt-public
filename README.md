
# Deploying Delta Live Tables Pipelines with Terraform

## About The Project

This repository contains example code for deploying Databricks [Delta Live Tables](https://docs.databricks.com/data-engineering/delta-live-tables/index.html) pipelines with [Terraform](https://www.terraform.io/).

[Delta Live Tables](https://docs.databricks.com/data-engineering/delta-live-tables/index.html) is a framework for building reliable, maintainable, and testable data processing pipelines. You define the transformations to perform on your data, and Delta Live Tables manages task orchestration, cluster management, monitoring, data quality, and error handling.

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure. The [Terraform "databricks_pipeline" Resource](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/pipeline) is used to deploy Delta Live Tables.

## Built With
- [Terraform](https://www.terraform.io/)
- [Delta Live Tables](https://docs.databricks.com/data-engineering/delta-live-tables/index.html)
- [Python](https://www.python.org/)
- [PySpark](https://spark.apache.org/docs/latest/api/python/#:~:text=PySpark%20is%20an%20interface%20for,data%20in%20a%20distributed%20environment.)

## Getting Started

### Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Installation
1. Clone the repo
> `git clone https://github.com/husqvarnagroup/terraform-dlt-public.git`

2. Update var-files in config folder with your settings.
 
### Usage
1. Open a terminal and ensure you are logged into the desired AWS Profile:
> `$ aws sso login --profile <aws_profile_name>`

2. Initialize the Terraform backend:
> `$ terraform init`

3. Show the Terraform Plan to confirm everything works:
> `$ terraform plan -var-file=config/<var-file-name>.tfvars`

3. After confirming everything works, apply the changes:
> `$ terraform apply -var-file=config/<var-file-name>.tfvars`
