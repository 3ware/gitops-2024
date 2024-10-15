locals {
  valid_instance_types = ["t3.micro"]
}

variable "instance_type" {
  description = "(Required) Instance type to use. Should be within the free tier"
  type        = string
  default     = "t3.micro"
  nullable    = false
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

locals {
  valid_regions = ["us-east-1"]
}

variable "region" {
  description = "(Required) Name of the AWS region resources will be deployed into."
  type        = string
  default     = "us-east-1"
  nullable    = false

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
