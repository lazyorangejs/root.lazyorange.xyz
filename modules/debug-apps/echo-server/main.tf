locals {
  enabled = var.enabled ? 1 : 0
  version = "0.6.0"
}

# https://gitlab.com/gitlab-org/charts/auto-deploy-app
# https://charts.gitlab.io/
resource "helm_release" "echo_server" {
  count = local.enabled
  name  = var.release_name

  repository = "https://charts.gitlab.io/"
  chart      = "auto-deploy-app"

  version = local.version

  atomic           = true
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    file("${path.module}/values.yaml"),
    var.ingress_values
  ]

  set {
    name  = "service.url"
    value = var.service_url
  }
}
