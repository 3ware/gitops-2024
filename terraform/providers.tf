terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

locals {
  # Defines a list of permitted environment tag values. Used by the postcondition in the aws_default_tags data source
  # to validate the environment tag extrapolated from the workspace name by the local values below
  valid_environment = ["development", "production"]
  workspace_split   = split("-", terraform.workspace)
  environment       = element(local.workspace_split, length(local.workspace_split) - 1)
}

# trunk-ignore(tflint/terraform_unused_declarations): Data source used to validate environment tag
data "aws_default_tags" "this" {
  lifecycle {
    postcondition {
      condition = anytrue([
        for tag in values(self.tags) : contains(local.valid_environment, tag)
      ])
      error_message = format(
        "Invalid environment tag specified. Received: '%s', Require: '%s'.\n%s",
        # TODO: This should be the actual value received self?
        local.environment,
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
      "3ware:project-id"      = "gitops-2024"
      "3ware:environment"     = local.environment
      "3ware:managed-by-tofu" = true
      "3ware:workspace"       = terraform.workspace
    }
  }
}
