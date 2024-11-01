data "sops_file" "aws_account_id" {
  source_file = "${path.module}/.sops-files/sensitive.enc.yaml"
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [data.sops_file.aws_account_id.data["dev_aws_account_id"]]
  default_tags {
    tags = {
      "3ware:project-id"           = var.project_id
      "3ware:environment"          = var.environment
      "3ware:managed-by-terraform" = true
      "3ware:workspace"            = terraform.workspace
    }
  }
}
