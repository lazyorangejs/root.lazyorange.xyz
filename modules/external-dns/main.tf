variable "enabled" {
  type    = bool
  default = true
}

variable "do_token" {
  type = string
  default = ""
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}

locals {
  external_dns_enabled = var.enabled ? 1 : 0
  provider             = "digitalocean"
}

# https://github.com/bitnami/charts/tree/master/bitnami/external-dns
resource "helm_release" "external_dns" {
  count = local.external_dns_enabled

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  name      = "external-dns"
  namespace = "kube-system"

  create_namespace = true
  atomic           = true
  wait             = true

  set {
    name  = "image.tag"
    value = "0.7.1-debian-10-r37"
  }

  set {
    name  = "provider"
    value = local.provider
  }

  set_sensitive {
    name  = "digitalocean.apiToken"
    value = var.do_token
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  set {
    name  = "interval"
    value = "30s"
  }

  values = []
}