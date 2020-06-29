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
  default     = ""
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

locals {
  do_token_provided = length(var.do_token) > 0
  cf_token_provided = length(var.cf_token) > 0

  external_dns_enabled = var.enabled && (local.do_token_provided || local.cf_token_provided) ? 1 : 0


  providers = {
    scaleway     = "cloudflare"
    digitalocean = "digitalocean"
  }

  # DNS provider where the DNS records will be created (mandatory) (options: aws, azure, google, ...)
  provider = length(var.ext_dns_provider) > 0 ? var.ext_dns_provider : lookup(local.providers, var.kubernetes.k8s_provider, "cloudflare")
}

# https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md
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

  values = []
}