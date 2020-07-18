# Cert Manager v0.15.0
# It requires permissions for creating namespaces and installing CRDs
#
module "cert_manager" {
  source = "../../modules/cert-manager"

  enabled    = local.ingress_stack.cert_manager_enabled
  kubernetes = local.kubernetes

  defaultIssuerName = var.default_issuer_name
  domain            = var.domain
  letsEncryptEmail  = local.letsEncryptEmail
  ingress_classes   = local.ingress_settings.ingress_class
}

resource "helm_release" "cert_manager_http_issuers" {
  count = (module.cert_manager.i_am_ready && local.ingress_stack.cert_manager_enabled && length(local.letsEncryptEmail) > 0) ? 1 : 0

  chart = "${pathexpand(path.module)}/../../modules/cert-manager/cert-manager-issuers"
  name  = "cert-manager-http-issuers"

  atomic           = true
  create_namespace = true

  namespace = "cert-manager"

  values = [
    yamlencode({
      clusterIssuer = {
        http01 = {
          ingressClass = local.ingress_settings.ingress_class
        }
      }
    })
  ]

  set {
    name  = "clusterIssuer.challengeProvider"
    value = "http01"
  }

  # https://github.com/jetstack/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml#L27
  set {
    name  = "clusterIssuer.letsEncryptEmail"
    value = local.letsEncryptEmail
  }
}

resource "helm_release" "cert_manager_digitalocean_issuer" {
  count = (module.cert_manager.i_am_ready && local.ingress_stack.cert_manager_enabled && length(var.do_token) > 0) ? 1 : 0

  chart = "${pathexpand(path.module)}/../../modules/cert-manager/cert-manager-issuers"
  name  = "digitalocean-cluster-issuer"

  atomic    = true
  namespace = "cert-manager"

  set {
    name  = "clusterIssuer.challengeProvider"
    value = "digitalocean"
  }

  set {
    name  = "clusterIssuer.letsEncryptEmail"
    value = local.letsEncryptEmail
  }

  set_sensitive {
    name  = "doToken"
    value = var.do_token
  }
}

resource "helm_release" "cloudflare_cluster_issuer" {
  count = (module.cert_manager.i_am_ready && local.ingress_stack.cert_manager_enabled && length(var.cf_token) > 0) ? 1 : 0

  chart = "${pathexpand(path.module)}/../../modules/cert-manager/cert-manager-issuers"
  name  = "cloudflare-cluster-issuer"

  atomic    = true
  namespace = "cert-manager"

  set {
    name  = "clusterIssuer.challengeProvider"
    value = "cloudflare"
  }

  set_sensitive {
    name  = "cfToken"
    value = var.cf_token
  }

  set {
    name  = "clusterIssuer.letsEncryptEmail"
    value = local.letsEncryptEmail
  }
}
