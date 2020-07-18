provider "helm" {
  version = "1.2"

  kubernetes {
    load_config_file = false

    host                   = local.kubernetes.kubernetes_endpoint
    token                  = local.kubernetes.kubernetes_token
    cluster_ca_certificate = base64decode(local.kubernetes.kubernetes_ca_cert)
  }
}