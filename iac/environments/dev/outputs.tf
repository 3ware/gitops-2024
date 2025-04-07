output "grafana_ip" {
  description = "The public IP address of the Grafana instance"
  value       = module.gitops_2024.grafana_ip
}
