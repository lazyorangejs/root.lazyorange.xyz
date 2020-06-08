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
  })

  default = {
    sentry = {
      enabled = false
      dsn     = ""
    }
  }
}

variable "prometheus_operator_enabled" {
  type    = bool
  default = true
}

variable "metrics_server_enabled" {
  type    = bool
  default = false
}

variable "kube_state_metrics_enabled" {
  type    = bool
  default = false
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}