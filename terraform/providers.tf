terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "3ware:project-id"      = "gitops-2024"
      "3ware:environment"     = var.environment
      "3ware:managed-by-tofu" = true
    }
  }
}
