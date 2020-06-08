locals {
  enabled = var.enabled && length(var.client.clientID) > 0 && length(var.client.clientSecret) > 0 ? 1 : 0
  version = "3.1.0"

  accounts_page_url = "accounts.${var.domain}"
}

# - https://github.com/oauth2-proxy/oauth2-proxy
# - https://github.com/helm/charts/tree/master/stable/oauth2-proxy#configuration
# - https://oauth2-proxy.github.io/oauth2-proxy/auth-configuration#gitlab-auth-provider
resource "helm_release" "oauth2_proxy" {
  count = local.enabled

  name       = "oauth2-proxy"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  chart   = "oauth2-proxy"
  version = local.version

  atomic    = true
  namespace = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", merge(var.client, {
      domain       = var.domain
      host         = length(local.accounts_page_url) > 0 ? local.accounts_page_url : "chart-example.local"
      ingressClass = var.ingressClass
    }))
  ]

  set {
    name  = "ingress.enabled"
    value = length(local.accounts_page_url) > 0 ? "true" : "false"
  }

  set {
    name  = "ingress.hosts[0]"
    value = length(local.accounts_page_url) > 0 ? local.accounts_page_url : "chart-example.local"
  }
}
