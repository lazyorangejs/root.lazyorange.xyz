variable "enabled" {
  type    = bool
  default = true
}

variable "domain" {
  type        = string
  description = "Domain name will be used to expose accounts page to authenticate users, e.g. accounts.lab.lazyorange.xyz"
}

variable "client" {
  type = object({
    provider     = string,
    clientID     = string
    clientSecret = string
    gitlabGroup  = string
  })
}

variable "ingressClass" {
  type    = string
  default = "nginx"
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
    namespace           = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}