module "prometheus_operator" {
  source  = "../../modules/prometheus-operator"
  enabled = var.enabled && var.prometheus_operator_enabled

  kubernetes = local.kubernetes

  grafana_url = format("grafana.%s", local.domain)
}