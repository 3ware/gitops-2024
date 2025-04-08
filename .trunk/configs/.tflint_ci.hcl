# TFLint configuration file for CI/CD pipelines
plugin "terraform" {
  enabled = true
  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.38.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"

  # Deep check can be enabled in CI/CD pipelines, where AWS credentials are set
  deep_check = true
}
