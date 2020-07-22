module "nginx_infra_ingress" {
  source = "../../modules/nginx-ingress"

  enabled       = var.enabled && var.settings.infra_nginx_ingress.enabled
  ingress_class = var.settings.infra_nginx_ingress.ingress_class

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
