module "nginx_ingress" {
  source  = "../../modules/nginx-ingress"
  enabled = local.sso_settings.enabled

  kubernetes = merge(var.kubernetes, { namespace = "ingress-nginx" })

  helm_values = yamlencode({
    controller = {
      antiAffinity = "hard",
      kind         = "Deployment",
      autoscaling = {
        enabled = false
      },
      nodeSelector = {}
    },
    defaultBackend = {
      antiAffinity = "hard",
      kind         = "Both",
      nodeSelector = {}
    }
  })
}

module "cluster_auth" {
  source  = "../../modules/auth/cluster-auth"
  enabled = false

  kubernetes = merge(var.kubernetes, { namespace = "kube-system" })
}

module "oauth2_proxy" {
  source = "../../modules/auth/oauth2-proxy"

  enabled      = local.sso_settings.enabled
  domain       = local.sso_settings.domain
  ingressClass = local.sso_settings.ingressClass

  // https://gitlab.com/oauth/applications/145843
  client = merge(local.sso_settings, {
    provider    = "gitlab",
    gitlabGroup = local.sso_settings.gitlabGroup
  })

  kubernetes = merge(var.kubernetes, { namespace = "cluster-idp" })
}

module "keycloak" {
  source = "../../modules/auth/keycloak"

  enabled  = local.sso_settings.keycloak.enabled
  app_name = "keycloak"

  ingress_values = templatefile(
    "${path.module}/keycloak-ingress-values.yaml",
    {
      ingressClass = local.sso_settings.ingressClass
      host         = "idp.${local.sso_settings.domain}"
    }
  )

  kubernetes = merge(var.kubernetes, { namespace = "cluster-idp" })
}