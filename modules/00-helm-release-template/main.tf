locals {
  enabled = var.enabled ? 1 : 0
  version = "CHANGE_ME"
}

resource "helm_release" "CHANGE_ME" {
  count = local.enabled

  name       = var.app_name
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "CHANGE_ME"
  version = local.version

  atomic           = true
  create_namespace = true
  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]

  set {
    name  = "foo"
    value = "bar"
  }
}
