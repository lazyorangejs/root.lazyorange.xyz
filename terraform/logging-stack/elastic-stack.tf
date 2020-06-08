module "elastic_stack" {
  source     = "../../modules/elastic-stack/elasticsearch-kibana-filebeat"
  kubernetes = local.kubernetes

  enabled    = local.settings.enabled && local.settings.elastic_stack.enabled
  server_url = local.settings.kibana_url

  helm_values_file    = pathexpand("${path.module}/values.yaml")
  ingress_values_file = pathexpand("${path.module}/kibana-ingress-values.yaml")
}