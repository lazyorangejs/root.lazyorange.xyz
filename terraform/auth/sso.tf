module "nginx_ingress" {
  source = "../../modules/nginx-ingress"

  enabled       = var.settings.enabled
  ingress_class = var.settings.ingress_class

  kubernetes = merge(var.kubernetes, {
    namespace = "ingress-nginx"
  })

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

  enabled      = var.settings.enabled
  domain       = var.settings.domain
  ingressClass = var.settings.ingress_class

  client = merge(var.settings, {
    provider    = "gitlab",
    gitlabGroup = var.settings.gitlabGroup
  })

  kubernetes = merge(var.kubernetes, { namespace = "cluster-idp" })
}

module "keycloak" {
  source = "../../modules/auth/keycloak"

  enabled  = var.settings.keycloak.enabled
  app_name = "keycloak"

  ingress_values = templatefile(
    "${path.module}/keycloak-ingress-values.yaml",
    {
      ingressClass = var.settings.ingress_class
      host         = "idp.${var.settings.domain}"
    }
  )

  kubernetes = merge(var.kubernetes, { namespace = "cluster-idp" })
}