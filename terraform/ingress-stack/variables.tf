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
  description = "(Optional) A cloudflare token, will be used to setup DNS records by using ExternalDNS"
}

variable "domain" {
  type = string
}

variable "default_issuer_name" {
  type = string
}

variable "settings" {
  type = object({
    kong = object({ enabled = bool })

    cert_manager = object({
      enabled          = bool,
      letsEncryptEmail = string
    })

    ingress_class = list(string)

    external_dns = object({ enabled = bool })
  })

  default = {
    kong          = { enabled = true },
    ingress_class = [""]
    cert_manager  = { enabled = true, letsEncryptEmail = "" },
    external_dns  = { enabled = true }
  }
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
    k8s_provider        = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}