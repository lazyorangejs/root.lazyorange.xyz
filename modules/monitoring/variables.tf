variable "enabled" {
  type    = bool
  default = false
}

variable "metrics_server_enabled" {
  type    = bool
  default = false
}

variable "kube_state_metrics_enabled" {
  type    = bool
  default = false
}

# - https://blog.sentry.io/2019/04/17/surface-kubernetes-errors-with-sentry
variable "sentry" {
  type = object({
    enabled = bool
    dsn     = string
  })

  default = {
    enabled = false
    dsn     = ""
  }
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