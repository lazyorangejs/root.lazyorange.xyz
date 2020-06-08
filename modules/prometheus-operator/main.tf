locals {
  enabled = var.enabled ? 1 : 0
  version = "8.13.7"
}

# https://github.com/helm/charts/tree/master/stable/prometheus-operator
resource "helm_release" "prometheus_operator" {
  count = local.enabled

  name       = "prometheus-operator"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "prometheus-operator"
  version = local.version

  atomic           = false
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {
      grafana_url = var.grafana_url
    })
  ]

  # https://github.com/helm/charts/blob/master/stable/prometheus-operator/values.yaml#L1067
  set {
    name  = "prometheusOperator.enabled"
    value = "true"
  }

  set {
    name  = "prometheusOperator.manageCrds"
    value = "true"
  }

  # https://github.com/helm/charts/blob/master/stable/prometheus-operator/values.yaml
  # https://github.com/helm/charts/tree/master/stable/prometheus-operator#prometheus
  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  # https://github.com/helm/charts/tree/master/stable/prometheus-operator#alertmanager
  set {
    name  = "alertmanager.enabled"
    value = "true"
  }

  # https://github.com/helm/charts/tree/master/stable/prometheus-operator#grafana
  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }
}