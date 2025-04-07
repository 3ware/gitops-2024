variable "aws_environment" {
  description = <<EOT
    (Required) The AWS environment to deploy resources to.
    Valid values are: development, testing, staging, production.
    EOT
  type        = string
  nullable    = false
  validation {
    condition = contains(["development", "testing", "staging", "production"], var.aws_environment)
    error_message = format(
      "Invalid environment provided. Received: '%s', Require: '%v'.\n%s",
      var.aws_environment,
      join(", ", ["development", "testing", "staging", "production"]),
      "Change the environment variable value to one that is permitted."
    )
  }
}

variable "instance_type" {
  description = "(Required) Instance type to use. Should be within the free tier"
  type        = string

  validation {
    condition = contains(["t2.micro"], var.instance_type)
    error_message = format(
      "Invalid instance type provided. Received: '%s', Require: '%v'.\n%s",
      var.instance_type,
      join(", ", ["t2.micro"]),
      "Change the instance type variable to one that is permitted."
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
