module "cluster_settings" {
  source = "../modules/utils/cluster-settings"

  root_gitlab_project = ""
}

module "scaleway_k8s" {
  source = "../modules/cloud/scaleway"

  kubernetes_version = "1.16.9"
  cluster_name       = module.cluster_settings.cluster_name
}

// resource "local_file" "scalewey_k8s_config" {
//   sensitive_content = module.scaleway_k8s.kubernetes.kubeconfig
//   filename          = "${path.module}/.kube/config"
// }

/*
module "digitalocean_k8s" {
  source = "../modules/cloud/doks"

  kubernetes_version = "1.16"

  region       = "fra1"
  domain       = module.cluster_settings.settings.domain.name
  cluster_name = module.cluster_settings.cluster_name
}
*/

module "basic_example" {
  source = "../terraform"

  cf_token     = var.cf_token
  gitlab_token = var.gitlab_token

  root_gitlab_group_id = module.cluster_settings.settings.gitlab.group_id
  root_gitlab_project  = module.cluster_settings.settings.gitlab.infra_project_id

  idp_creds = var.idp_creds

  kubernetes = module.scaleway_k8s.kubernetes
}
