# TFLint configuration file for Trunk CLI
plugin "terraform" {
  enabled = true
  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"

  # Deep check disabled for Trunk CLI because VSCode fails to prepare the workspace with
  # AWS credential environment variables set
  deep_check = false
}