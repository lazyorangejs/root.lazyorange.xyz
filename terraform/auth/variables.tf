variable "settings" {
  type = object({
    enabled = bool

    domain        = string
    ingress_class = string

    clientID     = string
    clientSecret = string
    gitlabGroup  = string

    keycloak = object({
      enabled = bool
    })
  })
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}
