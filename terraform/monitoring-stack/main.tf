module "monitoring" {
  source     = "../../modules/monitoring"
  kubernetes = local.kubernetes

  enabled                    = var.enabled
  metrics_server_enabled     = var.settings.metrics_server.enabled
  kube_state_metrics_enabled = var.settings.kube_state_metrics.enabled
  sentry                     = var.settings.sentry
}