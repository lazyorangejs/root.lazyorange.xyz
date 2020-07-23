variable "enabled" {
  type    = bool
  default = true
}

variable "do_token" {
  type    = string
  default = ""
}

variable "cf_token" {
  type        = string
  default     = ""
  description = "(Optional) A cloudflare token, see more at https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md#setting-up-externaldns-for-services-on-cloudflare"
}

variable "ext_dns_provider" {
  type        = string
  description = "(Optional) DNS provider where the DNS records will be created (options: digitalocean, cloudflare, ...)"
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
    k8s_provider        = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}

# https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md
# https://github.com/bitnami/charts/tree/master/bitnami/external-dns
resource "helm_release" "external_dns" {
  count = var.enabled ? 1 : 0

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  name      = "external-dns"
  namespace = "kube-system"

  create_namespace = true
  atomic           = true
  wait             = true

  set {
    name  = "image.tag"
    value = "0.7.2-debian-10-r21"
  }

  set {
    name  = "provider"
    value = var.ext_dns_provider
  }

  set_sensitive {
    name  = "digitalocean.apiToken"
    value = var.do_token
  }

  # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md
  set_sensitive {
    name  = "cloudflare.apiToken"
    value = var.cf_token
  }

  set {
    name  = "cloudflare.proxied"
    value = false
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  set {
    name  = "interval"
    value = "30s"
  }

  set {
    name = "policy"
    value = "sync"
  }

  values = []
}