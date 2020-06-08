locals {
  cluster = yamldecode(file("${abspath(path.root)}/cluster.yaml")).cluster

  ingress_settings = merge({
    kong         = { enabled = true },
    cert_manager = { enabled = true },
    external_dns = { enabled = true }
  }, local.cluster.stacks.ingress)

  domain           = local.cluster.domain.name
  letsEncryptEmail = local.cluster.domain.letsEncryptEmail

  ingressClass = local.ingress_settings.kong.enabled ? "kong" : "nginx"

  ingress_stack = {
    enabled = local.cluster.enabled

    kong_enabled         = local.ingress_settings.kong.enabled
    cert_manager_enabled = local.ingress_settings.cert_manager.enabled
    external_dns_enabled = local.ingress_settings.external_dns.enabled
  }

  kubernetes = var.kubernetes
}