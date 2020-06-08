locals {
  enabled = var.enabled ? 1 : 0
  version = "0.2.3"
}

# https://github.com/helm/charts/tree/master/incubator/raw
# https://github.com/helm/charts/blob/master/incubator/raw/Chart.yaml
resource "helm_release" "elastic_auth" {
  count = local.enabled

  name       = "elastic-apm-auth"
  repository = "http://storage.googleapis.com/kubernetes-charts-incubator"

  chart     = "raw"
  version   = local.version
  atomic    = true
  namespace = var.kubernetes.namespace

  values = [
    file("${path.module}/values.yaml")
  ]
}
