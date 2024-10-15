terraform {
  required_version = ">= 1.8.2"

  cloud {
    organization = "3ware"
    hostname     = "app.terraform.io"

    workspaces {
      tags    = ["gitops", "mtc", "aws"]
      project = "gitops-2024"
    }
  }
}
