output "grafana_ip" {
  description = "The connection details of the grafana server."
  value       = "http://${aws_instance.grafana_server.public_ip}:3000"
}
