locals {
  domain     = var.domain
  kubernetes = merge(var.kubernetes, { namespace = "monitoring" })
}