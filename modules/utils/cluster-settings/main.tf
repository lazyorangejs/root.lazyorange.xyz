

data "gitlab_group" "this" {
  count = length(local.settings.gitlab_group_backend_id) > 0 ? 1 : 0

  group_id = local.gitlab_group_backend_id
}

locals {
  infraIngressClass = "nginx"

  cluster_file = "${abspath(path.root)}/cluster.yaml"
  cluster      = yamldecode(fileexists(local.cluster_file) ? file(local.cluster_file) : file("${path.module}/settings.yml")).cluster

  gitlab_group_backend_id = length(var.gitlab_group_id) > 0 ? var.gitlab_group_id : local.cluster.gitlab.group_id
  cluster_name            = "${replace("${data.gitlab_group.this.0.full_path}", "/", "-")}-${local.cluster.env}"

  sso = merge(local.cluster.sso, {
    enabled = true

    ingressClass = local.infraIngressClass
    gitlabGroup  = join("", data.gitlab_group.this.*.full_path)

    keycloak = {
      enabled = false
    }

    oauth2_proxy = {
      enabled = true
    }
  })

  defaultLetsEncryptIssuerName = "letsencrypt-prod"

  cert_manager_settings = {
    digitalocean = local.settings.doks_enabled && length(var.do_token) > 0 ? "digitalocean-issuer" : local.defaultLetsEncryptIssuerName
    default      = local.defaultLetsEncryptIssuerName
  }

  control_plane = lookup(local.cluster, "control_plane", { rancher = { enabled = false } })

  rancher_enabled = lookup(local.control_plane.rancher, "enabled", false)

  settings = merge(local.cluster, {
    doks_enabled     = local.cluster.enabled && local.cluster.cloud.provider == "digitalocean"
    scaleway_enabled = local.cluster.enabled && local.cluster.cloud.provider == "scaleway"

    gitlab = {
      # Setup CI/CD environment variables for Gitlab pipelines
      # for instance, https://gitlab.com/lazyorangejs/infra/lab.lazyorange.xyz
      infra_project_id = length(var.root_gitlab_project) > 0 ? var.root_gitlab_project : lookup(local.cluster.gitlab, "infra_project_id", "")
    }

    # https://gitlab.com/lazyorangejs/lab
    gitlab_group_backend_id = local.gitlab_group_backend_id
  })

  cert_manager = {
    defaultIssuerName = lookup(local.cert_manager_settings, local.cluster.cloud.provider, "default")
  }

  scopes = {
    dev         = "development"
    develop     = "development"
    development = "development"
    
    # https://gitlab.com/gitlab-org/gitlab-foss/-/blob/3ef9553486f5be24b6845fd10fc7e21e8121dedd/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml#L62
    staging     = "staging"
    # https://gitlab.com/gitlab-org/gitlab-foss/-/blob/3ef9553486f5be24b6845fd10fc7e21e8121dedd/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml#L122
    prod        = "production"
    production  = "production"
  }

  gitlab_env_scope = lookup(local.scopes, local.settings.env, "*")
}

output "doks_enabled" {
  value = local.settings.doks_enabled
}

output "cluster_enabled" {
  value = local.cluster.enabled
}

output "cluster_name" {
  value = local.cluster_name
}

output "rancher_enabled" {
  value = local.rancher_enabled
}

output "infraIngressClass" {
  value       = "nginx"
  description = "Default ingress class used across infrastructure services, don't use for internet facing services"
}

output "gitlab_env_scope" {
  value = local.gitlab_env_scope
}

output "settings" {
  value = merge(local.settings, { sso = local.sso, cert_manager = local.cert_manager })
}