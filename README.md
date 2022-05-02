
# Deploying Delta Live Tables Pipelines on AWS with Terraform

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

- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Install Databricks CLI](https://docs.databricks.com/dev-tools/cli/index.html)

### Installation
1. Clone the repo
```bash
$ git clone https://github.com/husqvarnagroup/terraform-dlt-public.git
```

2. Update the dev and live Terraform var-files in the config folder with your settings. The "backend-config" files contain settings for the Terraform S3 Backend and the "variables" files contain settings for the Delta Live Tables Pipeline.
- config/dev-backend-config.tfvars
- config/dev-variables.tfvars
- config/live-backend-config.tfvars
- config/live-variables.tfvars

 
## Usage
1. Open a terminal and ensure you are logged into the correct AWS Profile:
```bash
$ aws sso login --profile <aws_profile_name>
```

2. Initialize the Terraform backend with the dev or live backend configuration file with [terraform init](https://www.terraform.io/cli/commands/init):
```bash
$ terraform init -backend-config config/<dev-or-live>-backend-config.tfvars
```
If changing between dev and live configurations you must include the -reconfigure flag:
```bash
$ terraform init -reconfigure -backend-config config/<dev-or-live>-backend-config.tfvars
```

3. Show the Terraform Plan with the dev or live variables file to confirm everything works:
```bash
$ terraform plan -var-file=config/<dev-or-live>-variables.tfvars
```

4. After confirming everything works, apply the changes with the dev or live variables file:
```bash
$ terraform apply -var-file=config/<dev-or-live>-variables.tfvars
```

5. To delete the previously deployed resources:
```bash
$ terraform destroy -var-file=config/<dev-or-live>-variables.tfvars
```

## Limitations
### Delta Live Tables Product Edition
It is not currently possible to define the [Delta Live Tables Product Edition](https://docs.microsoft.com/en-us/azure/databricks/data-engineering/delta-live-tables/delta-live-tables-concepts#product-editions) with the [Terraform "databricks_pipeline" Resource](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/pipeline). This must be done manually within Databricks itself.
### Delta Live Tables Development or Production Mode
It is not currently possible to define the [Delta Live Tables Development or Production mode](https://docs.microsoft.com/en-us/azure/databricks/data-engineering/delta-live-tables/delta-live-tables-concepts#--development-and-production-modes) with the [Terraform "databricks_pipeline" Resource](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/pipeline). This must be done manually within Databricks itself.

