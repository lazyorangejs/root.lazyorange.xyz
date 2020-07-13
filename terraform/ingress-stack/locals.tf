locals {
  ingress_settings = var.settings
  letsEncryptEmail = local.ingress_settings.cert_manager.letsEncryptEmail

  ingress_stack = {
    kong_enabled         = var.enabled && local.ingress_settings.kong.enabled
    cert_manager_enabled = var.enabled && local.ingress_settings.cert_manager.enabled
    external_dns_enabled = var.enabled && local.ingress_settings.external_dns.enabled
  }

  kubernetes = var.kubernetes
}