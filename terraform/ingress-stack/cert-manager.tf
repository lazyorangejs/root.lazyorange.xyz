# Cert Manager v0.15.0
# It requires permissions for creating namespaces and installing CRDs
#
module "cert_manager" {
  source = "../../modules/cert-manager"

  enabled    = local.ingress_stack.cert_manager_enabled
  kubernetes = local.kubernetes

  defaultIssuerName = var.defaultIssuerName
  letsEncryptEmail  = local.letsEncryptEmail
  ingressClass      = local.ingressClass
  domain            = var.domain
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