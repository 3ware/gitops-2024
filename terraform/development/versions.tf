terraform {
  required_version = ">= 1.8.2"

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
