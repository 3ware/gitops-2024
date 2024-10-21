output "aws_account_id" {
  description = "AWS account number resources are deployed into"
  value       = data.aws_caller_identity.current.account_id
  sensitive   = true
}

output "default_tags" {
  description = "A map of default tags applied to resources."
  value       = data.aws_default_tags.this.tags
}

output "grafana_ip" {
  description = "The connection details of the grafana server."
  value       = "http://${aws_instance.grafana_server.public_ip}:3000"
}
