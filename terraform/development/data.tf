# The locals in this file are used across multiple .tf files
locals {
  workspace_split = split("-", terraform.workspace)
  environment     = element(local.workspace_split, length(local.workspace_split) - 1)
}
