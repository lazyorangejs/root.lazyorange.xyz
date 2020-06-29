module "cluster_settings" {
  source = "../modules/utils/cluster-settings"

  root_gitlab_project = ""
  # gitlab_group_id     = module.gitlab_group.id
  # root_gitlab_project = module.gitlab_group.infra_project_id
}

module "digitalocean_k8s" {
  source = "../modules/cloud/doks"

  kubernetes_version = "1.16"

  region       = "fra1"
  domain       = module.cluster_settings.settings.domain.name
  cluster_name = module.cluster_settings.cluster_name
}

module "digital_ocean_basic_example" {
  source = "../terraform"

  do_token     = var.do_token
  gitlab_token = var.gitlab_token

  root_gitlab_group_id = module.cluster_settings.settings.gitlab.group_id
  root_gitlab_project  = module.cluster_settings.settings.gitlab.infra_project_id

  kubernetes = module.digitalocean_k8s.kubernetes
}
