module "kong" {
  source     = "../../modules/kong-ingress"
  kubernetes = merge(local.kubernetes, { namespace = "ingress-kong" })

  // get rid of this param in favour of postgres params, e.g setup postgres outside of module and pass all required params
  pg_k8s_enabled = false
  enabled        = local.ingress_stack.enabled && local.ingress_stack.kong_enabled
}