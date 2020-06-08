
# https://www.terraform.io/docs/providers/helm/index.html
#
provider "helm" {
  version = "1.2"

  kubernetes {
    load_config_file = false

    host                   = var.kubernetes.kubernetes_endpoint
    token                  = var.kubernetes.kubernetes_token
    cluster_ca_certificate = base64decode(var.kubernetes.kubernetes_ca_cert)
  }
}