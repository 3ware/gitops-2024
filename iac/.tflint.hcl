plugin "terraform" {
  enabled = true
  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.41.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  deep_check = false
}
