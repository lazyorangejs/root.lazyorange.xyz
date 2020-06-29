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
    value = var.add_local
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

output "i_am_ready" {
  value       = true
  sensitive   = false
  depends_on  = [
    helm_release.rancher_server
  ]
}
