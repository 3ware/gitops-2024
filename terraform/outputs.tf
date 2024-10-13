output "grafana_ip" {
  value = "http://${aws_instance.grafana_server.public_ip}:3000"
}
