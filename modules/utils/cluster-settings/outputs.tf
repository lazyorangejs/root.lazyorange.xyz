output "cluster_enabled" {
  value = local.cluster.enabled
}

output "cluster_name" {
  value = local.cluster_name
}

output "rancher_enabled" {
  value = lookup(local.control_plane.rancher, "enabled", false)
}

output "gitlab_env_scope" {
  value = local.gitlab_env_scope
}

output "settings" {
  value = merge(local.settings, {
    idp                         = local.idp_settings,
    default_infra_ingress_class = local.defaultInfraIngressClass
    sso                         = local.sso,
    cert_manager = {
      defaultIssuerName = lookup(local.cert_manager_settings, local.cluster.cloud.provider, local.defaultLetsEncryptIssuerName)
    },
    ingress    = local.ingress_settings
    monitoring = merge(local.monitoring_settings, { idp_credentials = local.idp_settings })
  })
}