terraform {
  required_version = ">= 1.8.2"

  cloud {
    organization = "3ware"
    hostname     = "app.terraform.io"

    workspaces {
      name = "gitops-2024"
    }
  }
}
