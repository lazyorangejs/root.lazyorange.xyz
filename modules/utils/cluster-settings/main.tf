locals {
  defaultInfraIngressClass     = lookup(local.cluster.infra.nginx, "class", "nginx-infra")
  defaultLetsEncryptIssuerName = format("letsencrypt-%s-prod", local.defaultInfraIngressClass)

  cluster_file = "${abspath(path.root)}/cluster.yaml"
  cluster      = yamldecode(fileexists(local.cluster_file) ? file(local.cluster_file) : file("${path.module}/settings.yml")).cluster

  gitlab_group_id = length(var.gitlab_group_id) > 0 ? var.gitlab_group_id : local.cluster.gitlab.group_id
  cluster_name    = "${replace("${data.gitlab_group.this.0.full_path}", "/", "-")}-${local.cluster.env}"

  control_plane = lookup(local.cluster, "control_plane", { rancher = { enabled = false } })

  idp_settings = merge(var.idp_credentials, {
    enabled = (length(var.idp_credentials.clientID) > 0 && length(var.idp_credentials.clientSecret) > 0)
  })

  sso = merge(local.cluster.sso, {
    enabled = true

    ingress_class = local.defaultInfraIngressClass
    gitlabGroup   = join("", data.gitlab_group.this.*.full_path)

    keycloak = {
      enabled = false
    }

    oauth2_proxy = {
      enabled = true
    }
  })

  cert_manager_settings = {
    digitalocean = local.settings.doks_enabled && length(var.do_token) > 0 ? "digitalocean-issuer" : local.defaultLetsEncryptIssuerName
    scaleway     = local.settings.scaleway_enabled && length(var.cf_token) > 0 ? "cloudflare-cluster-issuer" : local.defaultLetsEncryptIssuerName
  }

  settings = merge(local.cluster, {
    doks_enabled     = local.cluster.enabled && local.cluster.cloud.provider == "digitalocean"
    scaleway_enabled = local.cluster.enabled && local.cluster.cloud.provider == "scaleway"

    gitlab = {
      # Setup CI/CD environment variables for Gitlab pipelines
      # for instance, https://gitlab.com/lazyorangejs/infra/lab.lazyorange.xyz
      infra_project_id = length(var.root_gitlab_project) > 0 ? var.root_gitlab_project : lookup(local.cluster.gitlab, "infra_project_id", "")
      # https://gitlab.com/lazyorangejs/lab
      group_id = local.gitlab_group_id
    }
  })

  scopes = {
    dev         = "development"
    develop     = "development"
    development = "development"

    # https://gitlab.com/gitlab-org/gitlab-foss/-/blob/3ef9553486f5be24b6845fd10fc7e21e8121dedd/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml#L62
    staging = "staging"
    # https://gitlab.com/gitlab-org/gitlab-foss/-/blob/3ef9553486f5be24b6845fd10fc7e21e8121dedd/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml#L122
    prod       = "production"
    production = "production"
  }

  gitlab_env_scope = lookup(local.scopes, local.settings.env, "*")

  monitoring_settings = merge(lookup(local.cluster.stacks, "monitoring", {}), {
    ingress_class = local.defaultInfraIngressClass
  })

  ingress_settings = merge(local.cluster.stacks.ingress, {
    ingress_class = [local.defaultInfraIngressClass]

    external_dns = {
      enabled      = length(var.do_token) > 0 || length(var.cf_token) > 0
      dns_provider = lookup(local.cluster.domain, "dns_provider", )
    }

    infra_nginx_ingress = {
      enabled       = local.cluster.enabled
      ingress_class = local.defaultInfraIngressClass
    }

    cert_manager = {
      enabled          = local.cluster.stacks.ingress.cert_manager.enabled
      letsEncryptEmail = local.cluster.domain.letsEncryptEmail
    }
  })
}
