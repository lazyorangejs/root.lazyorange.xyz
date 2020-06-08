output "elastic_apm_url" {
  value = length(var.server_url) > 0 ? var.server_url : "http://apm-server.logging:8200"
}