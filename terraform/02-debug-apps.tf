module "echo_server" {
  source = "../modules/debug-apps/echo-server"

  enabled    = local.debug_services.enabled && local.debug_services.echo_server_enabled
  kubernetes = merge(local.kubernetes, { namespace = "default" })

  service_url = format("echo.%s", local.domain)
}

module "echo_server_nginx" {
  source = "../modules/debug-apps/echo-server"

  enabled    = local.debug_services.enabled && local.debug_services.echo_server_enabled
  kubernetes = merge(local.kubernetes, { namespace = "debug-apps" })

  service_url = format("echo-nginx.%s", local.domain)

  ingress_values = templatefile(
    "${path.module}/debug-apps/echo-server-nginx-ingress-values.yaml",
    {
      ingressClass          = module.cluster_settings.settings.default_infra_ingress_class
      oauthExternalAuthHost = format("accounts.%s", local.domain)
    }
  )
}

module "httpbin_server" {
  source = "../modules/debug-apps/httpbin-server"

  enabled    = local.debug_services.enabled && local.debug_services.httpbin_server_enabled
  kubernetes = local.kubernetes

  service_url = format("httpbin.%s", local.domain)
}
