terraform {
  required_version = ">=1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

locals {
  valid_account_no = {
    development = "713881824542"
    production  = "535002868697"
  }
}

data "aws_caller_identity" "current" {
  lifecycle {
    postcondition {
      condition = contains(values(local.valid_account_no), self.id)
      error_message = format(
        "Invalid AWS account ID specified. Received: '%s', Require: '%s'.\n%s",
        self.id,
        join(", ", values(local.valid_account_no)),
        "Configure AWS credentials to assume the correct role."
      )
    }
  }
}

locals {
  # Defines a list of permitted environment tag values. Used by the postcondition in the aws_default_tags data source
  # to validate the environment tag extrapolated from the workspace name in data.tf
  valid_environment = ["development", "production"]
}

data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition = anytrue([
        for tag in values(self.tags) : contains(local.valid_environment, tag)
      ])
      error_message = format(
        "Invalid environment tag specified. Received: '%s', Require: '%s'.\n%s",
        self.tags["3ware:environment"],
        join(", ", local.valid_environment),
        "Rename workspace with a valid environment suffix."
      )
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "3ware:project-id"           = var.project_id
      "3ware:environment"          = local.environment
      "3ware:managed-by-terraform" = true
      "3ware:workspace"            = terraform.workspace
    }
  }
}
