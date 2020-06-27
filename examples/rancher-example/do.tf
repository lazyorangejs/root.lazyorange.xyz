/*
module "digitalocean" {
  source  = "../../modules/cloud/doks"
  enabled = true

  kubernetes_version = "1.16"
  region             = "fra1"
  cluster_name       = local.clusterName
  domain             = local.domain
}

locals {
  cloudProvider                = "digitalocean"
  kubernetes = module.digitalocean.kubernetes
  domain           = "do-rancher-example.lazyorange.xyz"
}
*/