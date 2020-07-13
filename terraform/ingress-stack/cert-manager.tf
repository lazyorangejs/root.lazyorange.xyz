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

module "cert_manager_digitalocean_issuer" {
  source = "../../modules/cert-manager-issuer"

  enabled    = module.cert_manager.i_am_ready && local.ingress_stack.cert_manager_enabled && length(var.do_token) > 0
  app_name   = "cert-manager-digitalocean-issuer"
  kubernetes = merge(local.kubernetes, { namespace = "cert-manager" })

  challengeProvider = "digitalocean"
  letsEncryptEmail  = local.letsEncryptEmail
  do_token          = var.do_token
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
}

provider "helm" {
  version = "1.2"

  kubernetes {
    load_config_file = false

    host                   = local.kubernetes.kubernetes_endpoint
    token                  = local.kubernetes.kubernetes_token
    cluster_ca_certificate = base64decode(local.kubernetes.kubernetes_ca_cert)
  }
}