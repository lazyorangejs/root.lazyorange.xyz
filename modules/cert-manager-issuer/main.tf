locals {
  enabled = var.enabled ? 1 : 0
  version = "CHANGE_ME"
}

resource "helm_release" "cert_manager_issuers" {
  count = (local.enabled == 1 && length(var.letsEncryptEmail) > 1) ? 1 : 0

  chart = pathexpand("${path.module}/../cert-manager/cert-manager-issuers")
  name  = var.app_name

  atomic           = true
  create_namespace = true

  namespace = "cert-manager"

  values = []

  set {
    name  = "clusterIssuer.challengeProvider"
    value = var.challengeProvider
  }

  # https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml#L27
  set {
    name  = "clusterIssuer.letsEncryptEmail"
    value = var.letsEncryptEmail
  }

  set {
    name  = "clusterIssuer.http01.ingressClass"
    value = var.ingressClass
  }

  set {
    name  = "doToken"
    value = var.do_token
  }
}