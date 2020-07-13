module "ingress_stack" {
  source = "../terraform/ingress-stack"

  domain              = local.domain
  kubernetes          = local.kubernetes
  do_token            = var.do_token
  cf_token            = var.cf_token
  default_issuer_name = module.cluster_settings.settings.cert_manager.defaultIssuerName
  settings            = module.cluster_settings.settings.ingress
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

  settings = merge(module.cluster_settings.settings.monitoring, {
    sentry = {
      enabled = length(var.sentry_dsn) > 0
      dsn     = var.sentry_dsn
    }
  })
}

module "auth" {
  source = "./auth"

  settings = merge(
    merge(var.idp_creds, { domain = local.domain }),
    module.cluster_settings.settings.sso
  )

  kubernetes = local.kubernetes
}