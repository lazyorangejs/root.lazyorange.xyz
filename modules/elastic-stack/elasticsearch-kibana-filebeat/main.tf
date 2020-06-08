locals {
  enabled = var.enabled ? 1 : 0
  version = "3.0.0"

  ingress_values = length(var.ingress_values_file) > 0 ? yamldecode(file(var.ingress_values_file)) : {}
  global_values  = length(var.helm_values_file) > 0 ? yamldecode(file(var.helm_values_file)) : {}

  kibana_values = merge(local.global_values, local.ingress_values)
}

# - https://github.com/elastic/helm-charts/tree/master/elasticsearch
# - https://github.com/elastic/helm-charts
# - https://gitlab.com/gitlab-org/charts/elastic-stack/-/blob/master/requirements.yaml
# - https://gitlab.com/gitlab-org/charts/elastic-stack/-/tree/master
resource "helm_release" "elastic_stack" {
  count = local.enabled

  name       = "elastic-stack"
  repository = "https://charts.gitlab.io"

  chart   = "elastic-stack"
  version = local.version

  atomic           = false
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    yamlencode({
      elasticsearch : merge(
        yamldecode(file("${path.module}/values.yaml")).elasticsearch,
        local.global_values
      )
      kibana : merge(
        yamldecode(file("${path.module}/values.yaml")).kibana,
        local.kibana_values
      )
    }),
    templatefile(
      "${path.module}/values.yaml",
      {
        host = length(var.server_url) > 0 ? var.server_url : "chart-example.local",
        elasticsearchHost = "elasticsearch-master.logging"
      }
    ),
  ]

  set {
    name = "kibana.ingress.enabled"
    value = length(var.server_url) > 0 ? "true" : "false"
  }

  set {
    name = "kibana.ingress.hosts[0]"
    value = length(var.server_url) > 0 ? var.server_url : "chart-example.local"
  }
}