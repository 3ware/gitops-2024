variable "instance_type" {}


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
