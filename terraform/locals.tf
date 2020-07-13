module "cluster_settings" {
  source = "../modules/utils/cluster-settings"

  root_gitlab_project = var.root_gitlab_project
  gitlab_group_id     = var.root_gitlab_group_id
  do_token            = var.do_token
  cf_token            = var.cf_token
  idp_credentials     = var.idp_creds
}

locals {
  kubernetes       = var.kubernetes
  domain           = module.cluster_settings.settings.domain.name
  letsEncryptEmail = module.cluster_settings.settings.domain.letsEncryptEmail

  gitlab_manage_project_id = module.cluster_settings.settings.gitlab.infra_project_id

  # debug services
  debug_services = {
    enabled = module.cluster_settings.settings.enabled

    echo_server_enabled    = true
    httpbin_server_enabled = true
  }
}