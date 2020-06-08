# firstly you should create the gitlab group then you will be able to create other resources
# $ terraform apply -auto-approve -target=module.gitlab_group
# $ terraform apply

module "gitlab_group" {
  source = "../../modules/testing/gitlab"
}

module "cluster_settings" {
  source = "../../modules/utils/cluster-settings"

  gitlab_group_id     = module.gitlab_group.id
  root_gitlab_project = module.gitlab_group.infra_project_id
}

module "scaleway_k8s" {
  source = "../../terraform/cloud/scaleway"

  kubernetes_version = "1.16.9"
  cluster_name       = module.cluster_settings.cluster_name
}

// this example will not install ExternalDNS thus LB record will not be synced due to lack of own DNS management on Scaleway
// you need to setup DNS zone and records manually
// in future version will be used CloudFlare as a DNS management solution
module "scaleway_basic_example" {
  source = "../../terraform"

  kubernetes   = module.scaleway_k8s.kubernetes
  gitlab_token = var.gitlab_token

  root_gitlab_group_id = module.gitlab_group.id
  root_gitlab_project  = module.gitlab_group.infra_project_id
}
