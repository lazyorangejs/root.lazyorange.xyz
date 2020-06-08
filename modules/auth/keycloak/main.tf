locals {
  enabled = var.enabled ? 1 : 0
  version = "8.2.2"
}

# - https://github.com/codecentric/helm-charts/tree/master/charts/keycloak
resource "helm_release" "keycloak" {
  count = local.enabled

  name       = var.app_name
  repository = "https://codecentric.github.io/helm-charts"

  chart   = "keycloak"
  version = local.version

  atomic           = true
  create_namespace = true
  namespace        = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {}),
    var.ingress_values
  ]

  set {
    name  = "foo"
    value = "bar"
  }
}
