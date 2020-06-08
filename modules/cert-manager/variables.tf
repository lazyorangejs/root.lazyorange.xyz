variable "enabled" {
  type    = bool
  default = true
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}

variable "credentials" {
  type = object({
    digitalocean = object({
      do_token = string
    })
  })

  default = {
    digitalocean = {
      do_token = ""
    }
  }
}

variable "domain" {
  type        = string
}

variable "ingressClass" {
  type    = string
  default = "nginx"
}

variable "defaultIssuerName"{
  type = string
  default = "letsencrypt-prod"
}

variable "letsEncryptEmail" {
  type    = string
  default = ""
}
