locals {
  ingress_settings = var.settings
  domain           = var.domain
  letsEncryptEmail = local.ingress_settings.cert_manager.letsEncryptEmail

  ingressClass = local.ingress_settings.kong.enabled ? "kong" : "nginx"

  ingress_stack = {
    kong_enabled         = var.enabled && local.ingress_settings.kong.enabled
    cert_manager_enabled = var.enabled && local.ingress_settings.cert_manager.enabled
    external_dns_enabled = var.enabled && local.ingress_settings.external_dns.enabled
  }

  kubernetes = var.kubernetes
}