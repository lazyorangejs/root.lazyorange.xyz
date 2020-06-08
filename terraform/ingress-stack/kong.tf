module "kong" {
  source     = "../../modules/kong-ingress"
  kubernetes = merge(local.kubernetes, { namespace = "ingress-kong" })

  pg_k8s_enabled = true
  enabled        = local.ingress_stack.enabled && local.ingress_stack.kong_enabled
}