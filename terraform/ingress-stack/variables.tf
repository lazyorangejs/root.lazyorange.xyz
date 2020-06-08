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

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}