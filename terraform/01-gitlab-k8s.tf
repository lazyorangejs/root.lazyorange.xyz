module "gitlab" {
  source = "./gitlab"

  gitlab_project_id = local.gitlab_manage_project_id
  gitlab_token      = var.gitlab_token
  do_token          = var.do_token

  s3_aws_access_key_id     = var.s3_aws_access_key_id
  s3_aws_secret_access_key = var.s3_aws_secret_access_key
}

module "gitlab_docker_registry" {
  source             = "../modules/auth/gitlab-docker-registry"
  enabled            = true
  k8s_secret_enabled = true

  gitlab_group_id = module.cluster_settings.settings.gitlab_group_backend_id
  kubernetes      = local.kubernetes
}

module "gitlab_k8s_cluster" {
  source = "git::https://gitlab.com/lazyorangejs/staging.lazyorange.xyz//terraform/module/gitlab-kube-cluster?ref=tags/v0.6.0"
  stage  = module.cluster_settings.gitlab_env_scope

  enabled                     = module.cluster_settings.cluster_enabled
  group_gitlab_runner_enabled = false

  dns_zone          = local.domain
  cluster_name      = module.cluster_settings.cluster_name
  root_gitlab_group = module.cluster_settings.settings.gitlab_group_backend_id

  kubernetes_token    = local.kubernetes.kubernetes_token
  kubernetes_endpoint = local.kubernetes.kubernetes_endpoint
  kubernetes_ca_cert  = local.kubernetes.kubernetes_ca_cert
}