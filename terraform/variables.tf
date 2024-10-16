locals {
  valid_instance_types = ["t3.micro"]
}

variable "instance_type" {
  description = "(Required) Instance type to use. Should be within the free tier"
  type        = string

  validation {
    condition = contains(local.valid_instance_types, var.instance_type)
    error_message = format(
      "Invalid instance type provided. Received: '%s', Require: '%v'.\n%s",
      var.instance_type,
      join(", ", local.valid_instance_types),
      "Change the instance type variable to one that is permitted."
    )
  }
}

variable "project_id" {
  description = "(Required) Name of the project"
  type        = string
}

locals {
  valid_regions = ["us-east-1"]
}

variable "region" {
  description = "(Required) Name of the AWS region resources will be deployed into."
  type        = string

  validation {
    condition = contains(local.valid_regions, var.region)
    error_message = format(
      "Invalid AWS region provided. Received: '%s', Require: '%v'.\n%s",
      var.region,
      join(", ", local.valid_regions),
      "Change the region variable to one that is permitted."
    )
  }
}

variable "subnet_cidr_block" {
  description = "(Required) A valid CIDR block to assign to the Grafana Server subnet"
  type        = string

  validation {
    condition = can(cidrhost(var.subnet_cidr_block, 0))
    error_message = format(
      "Invalid CIDR block provided. Received: '%s'\n%s",
      var.vpc_cidr_block,
      "Check the syntax of the CIDR block is valid."
    )
  }
}

variable "vpc_cidr_block" {
  description = "(Required) A valid CIDR block to assign to the VPC"
  type        = string

  validation {
    condition = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = format(
      "Invalid CIDR block provided. Received: '%s'\n%s",
      var.vpc_cidr_block,
      "Check the syntax of the CIDR block is valid."
    )
  }
}
