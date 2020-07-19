locals {
  enabled = var.enabled ? 1 : 0
  version = "8.13.7"

  gitlab_enabled = var.idp_credentials.enabled && var.idp_credentials.provider == "gitlab"
}

# https://github.com/helm/charts/tree/master/stable/prometheus-operator
resource "helm_release" "prometheus_operator_crd" {
  count = local.enabled

  name       = "prometheus-operator-crd"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "prometheus-operator"
  version = local.version

  atomic           = false
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/prometheus-operator.values.yaml", {})
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
    value = "false"
  }

  # https://github.com/helm/charts/tree/master/stable/prometheus-operator#alertmanager
  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  # https://github.com/helm/charts/tree/master/stable/prometheus-operator#grafana
  set {
    name  = "grafana.enabled"
    value = "false"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "false"
  }

  set {
    name  = "kubeStateMetrics.enabled"
    value = "false"
  }
}

output "i_am_ready" {
  value = true

  depends_on = [
    helm_release.prometheus_operator_crd
  ]
}

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
    templatefile("${path.module}/prometheus-operator.values.yaml", {}),
    local.gitlab_enabled ? templatefile("${path.module}/graphana-auth-gitlab.values.yaml", var.idp_credentials) : "",
    templatefile("${path.module}/values.yaml", {
      grafana_url  = var.grafana_url,
      ingressClass = var.ingress_class
    })
  ]

  # https://github.com/helm/charts/blob/master/stable/prometheus-operator/values.yaml#L1067
  set {
    name  = "prometheusOperator.enabled"
    value = "false"
  }

  set {
    name  = "prometheusOperator.manageCrds"
    value = "false"
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
  # https://github.com/helm/charts/tree/master/stable/grafana#configuration
  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name  = "kubeStateMetrics.enabled"
    value = "true"
  }

  depends_on = [
    helm_release.prometheus_operator_crd
  ]
}