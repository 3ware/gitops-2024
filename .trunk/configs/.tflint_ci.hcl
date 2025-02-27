# TFLint configuration file for CI/CD pipelines
plugin "terraform" {
  enabled = true
  preset = "all"
}

Enable the AWS plugin if required
plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"

  # Deep check can be enabled in CI/CD pipelines, where AWS credentials are set
  # This configuration file should be references using the `--config` flag
  # Example: https://github.com/3ware/aws-network-speciality/blob/79a2be0813e053f17ed4f802705f7b6f2c350f0d/.github/workflows/terraform-ci.yaml#L114
  deep_check = true
}