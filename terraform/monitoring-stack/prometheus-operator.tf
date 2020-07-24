module "prometheus_operator" {
  source  = "../../modules/prometheus-operator"
  enabled = var.enabled && var.settings.prometheus_operator.enabled

  kubernetes      = local.kubernetes
  ingress_class   = var.settings.ingress_class
  idp_credentials = var.settings.idp_credentials

  grafana_url    = format("grafana.%s", local.domain)
  prometheus_url = format("prometheus.%s", local.domain)
}

output "i_am_ready" {
  value       = module.prometheus_operator.i_am_ready
  description = "Helm charts such as Kong create service monitor resource thus CRD should be created firstly"
}
