variable "enabled" {
  type = bool
  default = true
}

variable "do_token" {
  type    = string
  default = ""
}

variable "domain" {
  type = string
}

variable "defaultIssuerName" {
  type = string
}

variable "settings" {
  type = object({
    kong         = object({ enabled = bool })
    cert_manager = object({
      enabled          = bool,
      letsEncryptEmail = string
    })
    external_dns = object({ enabled = bool })
  })

  default = {
    kong         = { enabled = true },
    cert_manager = { enabled = true, letsEncryptEmail = "" },
    external_dns = { enabled = true }
  }
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}