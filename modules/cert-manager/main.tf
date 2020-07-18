# https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager
resource "helm_release" "cert_manager" {
  count = local.cert_manager_enabled

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"

  chart   = "cert-manager"
  version = local.cert_manager_version

  atomic           = true
  create_namespace = true

  namespace = "cert-manager"

  values = [
    templatefile("${path.module}/values.yaml", {
      # https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml#L118
      defaultIssuerName = var.defaultIssuerName
    })
  ]

  # https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml#L27
  set {
    name  = "installCRDs"
    value = "true"
  }
}

output "i_am_ready" {
  value       = true
  description = ""

  depends_on = [
    helm_release.cert_manager
  ]
}
