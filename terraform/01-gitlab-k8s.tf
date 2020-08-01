module "gitlab_docker_registry" {
  source             = "../modules/auth/gitlab-docker-registry"
  enabled            = true
  k8s_secret_enabled = true

  gitlab_group_id = module.cluster_settings.settings.gitlab.group_id
  kubernetes      = local.kubernetes
}

module "gitlab_k8s_cluster" {
  source  = "lazyorangejs/kube-cluster/gitlab"
  version = "0.1.0-rc.0"

  enabled = module.cluster_settings.cluster_enabled

  stage             = module.cluster_settings.gitlab_env_scope
  dns_zone          = local.domain
  cluster_name      = module.cluster_settings.cluster_name
  root_gitlab_group = module.cluster_settings.settings.gitlab.group_id

  kubernetes_token    = local.kubernetes.kubernetes_token
  kubernetes_endpoint = local.kubernetes.kubernetes_endpoint
  kubernetes_ca_cert  = local.kubernetes.kubernetes_ca_cert
}