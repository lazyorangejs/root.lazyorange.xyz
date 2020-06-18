# $ terraform init
# $ terraform apply

locals {
  # https://gitlab.com/lazyorangejs/backend
  gitlab_group_id = "6638212"
  # https://gitlab.com/lazyorangejs/infra/dev.lazyorange.xyz
  gitlab_infra_project_id = "18549305"
}

module "cluster_settings" {
  source = "../../modules/utils/cluster-settings"

  gitlab_group_id     = local.gitlab_group_id
  root_gitlab_project = local.gitlab_infra_project_id
}

module "digitalocean_k8s" {
  source = "../../modules/cloud/doks"

  kubernetes_version = "1.16"

  region       = "fra1"
  domain       = module.cluster_settings.settings.domain.name
  cluster_name = module.cluster_settings.cluster_name
}

module "digital_ocean_basic_example" {
  source = "../../terraform"

  do_token     = var.do_token
  gitlab_token = var.gitlab_token

  root_gitlab_group_id = local.gitlab_group_id
  root_gitlab_project  = local.gitlab_infra_project_id

  kubernetes = module.digitalocean_k8s.kubernetes
}
