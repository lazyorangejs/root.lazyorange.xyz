locals {
  rancher_enabled  = var.enabled ? 1 : 0
  rancher_hostname = var.hostname
  rancher_version  = "2.4.3"

  letsEncryptEnabled = var.letsEncrypt.enabled
  letsEncryptEmail   = local.letsEncryptEnabled ? var.letsEncrypt.email : ""
}

# helm upgrade --namespace cattle-system --install --set addLocal=false --set hostname=rancher.lab.lazyorange.xyz rancher rancher-stable/rancher
# https://github.com/rancher/rancher/tree/master/chart
# https://github.com/rancher/rancher/blob/master/chart/values.yaml
resource "helm_release" "rancher_server" {
  count = local.rancher_enabled

  name       = "rancher-server"
  repository = "https://releases.rancher.com/server-charts/stable"

  chart   = "rancher"
  version = local.rancher_version

  atomic           = false
  create_namespace = true

  namespace = "cattle-system"

  values = [
    templatefile("${path.module}/values.yaml", {
      clusterIssuer = var.clusterIssuer,
      ingressClass  = var.ingressClass
    })
  ]

  set {
    name  = "hostname"
    value = var.hostname
  }

  set {
    name  = "addLocal"
    value = "false"
  }

  set {
    name  = "ingress.tls.source"
    value = var.ingressTlsSource
  }

  set {
    name  = "letsEncrypt.email"
    value = local.letsEncryptEmail
  }
}