module "elastic_apm_server" {
  source     = "../../modules/elastic-stack/apm"
  enabled    = local.settings.enabled && local.settings.apm.enabled
  server_url = local.settings.apm_server_url

  kubernetes          = local.kubernetes
  helm_values_file    = pathexpand("${path.module}/values.yaml")
  ingress_values_file = pathexpand("${path.module}/apm-ingress-values.yaml")
}

output "apm_server_url" {
  value = module.elastic_apm_server.elastic_apm_url
}