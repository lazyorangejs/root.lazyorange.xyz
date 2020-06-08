module "ingress_stack" {
  source = "./ingress-stack"

  domain            = local.domain
  kubernetes        = local.kubernetes
  do_token          = var.do_token
  defaultIssuerName = module.cluster_settings.settings.cert_manager.defaultIssuerName
}

module "logging_stack" {
  source = "./logging-stack"

  domain = local.domain

  kubernetes = merge(local.kubernetes, {
    namespace = "logging"
  })
}

module "monitoring_stack" {
  source  = "./monitoring-stack"
  enabled = true

  domain = local.domain

  kubernetes = merge(local.kubernetes, {
    namespace = "monitoring"
  })

  metrics_server_enabled      = true
  kube_state_metrics_enabled  = true
  prometheus_operator_enabled = false

  settings = {
    sentry = {
      enabled = length(var.sentry_dsn) > 0
      dsn     = var.sentry_dsn
    }
  }
}

module "auth" {
  source = "./auth"

  sso_settings = merge(
    merge(var.idp_creds, { domain = local.domain }),
    module.cluster_settings.settings.sso
  )

  kubernetes = local.kubernetes
}

# Rancher Server v2.4.3 (stable)
#
# You can't remove rancher by removing rancher helm chart.
# - https://rancher.com/docs/rancher/v2.x/en/faq/removing-rancher/#what-if-i-don-t-want-rancher-anymore
module "rancher_server" {
  source = "../modules/rancher"

  enabled    = module.cluster_settings.rancher_enabled
  kubernetes = local.kubernetes

  # https://rancher.com/docs/rancher/v2.x/en/installation/options/chart-options/#common-options
  # please note this module support letsEncrypt only, other options will be added later
  # your service should be available outside of private network
  letsEncrypt = {
    enabled = false
    email   = local.letsEncryptEmail
  }

  ingressClass     = "nginx"
  clusterIssuer    = module.cluster_settings.settings.cert_manager.defaultIssuerName
  ingressTlsSource = "secret"
  hostname         = format("rancher.%s", local.domain)
}

