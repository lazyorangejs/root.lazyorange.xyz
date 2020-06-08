# module "doks_cluster" {
#   source  = "./cloud/doks"
#   enabled = module.cluster_settings.doks_enabled

#   region = "fra1"

#   domain                = local.domain
#   cluster_name          = module.cluster_settings.cluster_name
#   elastic_stack_enabled = module.cluster_settings.settings.stacks.logging.enabled

#   kubernetes_version = var.kubernetes_version
# }

# locals {
#   kubernetes = module.doks_cluster.kubernetes
# }

# module "scaleway_cluster" {
#   source = "./cloud/scaleway"

#   enabled      = module.cluster_settings.scaleway_enabled
#   cluster_name = module.cluster_settings.cluster_name
# }

# locals {
#   kubernetes = module.scaleway_cluster.kubernetes
# }

locals {
  kubernetes = var.kubernetes
}