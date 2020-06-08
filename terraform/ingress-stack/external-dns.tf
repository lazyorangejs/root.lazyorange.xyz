module "external_dns" {
  source = "../../modules/external-dns"

  kubernetes = local.kubernetes

  enabled  = local.ingress_stack.enabled && local.ingress_stack.external_dns_enabled
  do_token = var.do_token
}
