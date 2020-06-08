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

resource "helm_release" "cert_manager_issuers" {
  count = (local.cert_manager_enabled == 1 && length(var.letsEncryptEmail) > 1) ? 1 : 0

  chart = pathexpand("${path.module}/cert-manager-issuers")
  name  = "cert-manager-issuers"

  atomic           = true
  create_namespace = true

  namespace = "cert-manager"

  values = []

  set {
    name = "clusterIssuer.challengeProvider"
    value = "http01"
  }

  # https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml#L27
  set {
    name  = "clusterIssuer.letsEncryptEmail"
    value = var.letsEncryptEmail
  }

  set {
    name = "clusterIssuer.http01.ingressClass"
    value = var.ingressClass
  }

  depends_on = [helm_release.cert_manager]
}