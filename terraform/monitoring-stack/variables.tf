variable "enabled" {
  type    = bool
  default = true
}

variable "domain" {
  type = string
}

variable "settings" {
  type = object({
    sentry = object({
      enabled = bool
      dsn     = string
    })

    idp_credentials = object({
      provider     = string
      enabled      = bool
      clientID     = string
      clientSecret = string
    })

    ingress_class = string

    prometheus_operator = object({
      enabled = bool
    })

    kube_state_metrics = object({
      enabled = bool
    })

    metrics_server = object({
      enabled = bool
    })
  })

  default = {
    sentry = {
      enabled = false
      dsn     = ""
    }

    ingress_class = "nginx"

    idp_credentials = {
      enabled      = false
      provider     = ""
      clientID     = ""
      clientSecret = ""
    }

    prometheus_operator = {
      enabled = false
    }

    kube_state_metrics = {
      enabled = true
    }

    metrics_server = {
      enabled = true
    }
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