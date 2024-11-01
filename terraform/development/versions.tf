terraform {
  # Must be above 1.9.0 to allow cross-object referencing for input variable validations
  required_version = ">=1.9.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.69.0"
    }
    # http = {
    #   source  = "hashicorp/http"
    #   version = "~>3.4.5"
    # }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1.1"
    }
  }
  cloud {
    organization = "3ware"
    hostname     = "app.terraform.io"

    workspaces {
      # Tags are used to when the workspace exists locally and workspace are used to separate the configuration
      # Set the TF_WORKSPACE environment variable in CI
      # tags    = ["gitops", "mtc", "aws"]
      name    = "app-us-east-1-development"
      project = "gitops-2024"
    }
  }
}
