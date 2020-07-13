locals {
  metrics_server_version     = "2.11.1"
  kube_state_metrics_version = "2.8.5"
}

# - https://github.com/helm/charts/tree/master/stable/metrics-server
resource "helm_release" "metrics_server" {
  count = var.enabled && var.metrics_server_enabled ? 1 : 0

  name       = "metrics-server"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "metrics-server"
  version = local.metrics_server_version

  atomic           = true
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]
}

# - https://github.com/helm/charts/tree/master/stable/kube-state-metrics
resource "helm_release" "kube_state_metrics" {
  count = var.enabled && var.kube_state_metrics_enabled ? 1 : 0

  name       = "kube-state-metrics"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "kube-state-metrics"
  version = local.kube_state_metrics_version

  atomic           = true
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]
}
