module "monitoring" {
  source     = "../../modules/monitoring"
  kubernetes = local.kubernetes

  enabled                    = var.enabled
  metrics_server_enabled     = var.metrics_server_enabled
  kube_state_metrics_enabled = var.kube_state_metrics_enabled
  sentry                     = var.settings.sentry
}