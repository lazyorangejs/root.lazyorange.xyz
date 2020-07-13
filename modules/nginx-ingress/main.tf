locals {
  enabled = var.enabled ? 1 : 0
  version = "2.3.0"

  global_values = yamldecode(length(var.helm_values) > 0 ? var.helm_values : "")
}

# https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx
# https://kubernetes.github.io/ingress-nginx/
# https://kubernetes.github.io/ingress-nginx/deploy/#using-helm
# https://github.com/kubernetes/ingress-nginx
resource "helm_release" "ingress_nginx" {
  count = local.enabled

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  chart   = "ingress-nginx"
  version = local.version

  create_namespace = true
  atomic           = true
  namespace        = var.kubernetes.namespace

  values = [
    yamlencode({
      controller : merge(
        yamldecode(file("${path.module}/values.yaml")).controller,
        local.global_values.controller
      )
      defaultBackend : merge(
        yamldecode(file("${path.module}/values.yaml")).defaultBackend,
        local.global_values.defaultBackend
      )
    })
  ]

  set {
    name  = "controller.ingressClass"
    value = var.ingress_class
  }
}
