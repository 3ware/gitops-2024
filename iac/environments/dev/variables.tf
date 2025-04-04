variable "aws_environment" {
  description = "(Required) The AWS environment to deploy resources to"
  type        = string
}

variable "aws_project" {
  description = "(Required) The AWS project to deploy resources to"
  type        = string
}

variable "aws_region" {
  description = "(Required) The AWS region to deploy resources to"
  type        = string
}

variable "aws_service" {
  description = "(Required) The AWS service being deployed"
  type        = string
}
