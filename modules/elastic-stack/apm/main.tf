locals {
  enabled = var.enabled ? 1 : 0
  version = "7.7.0"
}

# https://github.com/elastic/helm-charts/tree/master/apm-server
resource "helm_release" "apm_server" {
  count = local.enabled

  name       = "apm-server"
  repository = "https://helm.elastic.co"

  chart   = "apm-server"
  version = local.version

  atomic           = true
  create_namespace = false
  namespace        = var.kubernetes.namespace

  values = [
    length(var.helm_values_file) > 0 ? file(var.helm_values_file) : file("${path.module}/values.yaml"),
    templatefile(
      "${path.module}/values.yaml",
      {
        host = length(var.server_url) > 0 ? var.server_url : "chart-example.local"
      }
    ),
    length(var.ingress_values_file) > 0 ? file(var.ingress_values_file) : file("${path.module}/values.yaml")
  ]

  set {
    name  = "replicas"
    value = "3"
  }

  set {
    name  = "fullnameOverride"
    value = "apm-server"
  }

  set {
    name = "ingress.enabled"
    value = length(var.server_url) > 0 ? "true" : "false"
  }

  set {
    name = "ingress.hosts[0]"
    value = length(var.server_url) > 0 ? var.server_url : "chart-example.local"
  }
}
