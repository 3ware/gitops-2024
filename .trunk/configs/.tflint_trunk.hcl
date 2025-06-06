# TFLint configuration file for Trunk CLI
plugin "terraform" {
  enabled = true
  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.39.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"

  # Disabled for trunk because VSCode fails to prepare the workspace with AWS env vars enabled
  deep_check = false
}
