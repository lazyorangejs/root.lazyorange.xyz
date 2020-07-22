locals {
  enabled = var.enabled ? 1 : 0
  version = "0.8.0"
}

# https://gitlab.com/gitlab-org/charts/auto-deploy-app
# https://charts.gitlab.io/
resource "helm_release" "httpbin_server" {
  count = local.enabled

  name = "httpbin-server"

  repository = "https://charts.gitlab.io/"
  chart      = "auto-deploy-app"

  version = local.version

  atomic           = true
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {
      ingress_class = var.ingress_class
    })
  ]

  set {
    name  = "service.url"
    value = var.service_url
  }
}
