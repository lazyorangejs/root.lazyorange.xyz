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