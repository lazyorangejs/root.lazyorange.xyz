variable "enabled" {
  type    = bool
  default = true
}

variable "prometheus_url" {
  type = string
}

variable "grafana_url" {
  type = string
}

variable "ingress_class" {
  type        = string
  description = "(Required) Ingress class is used as a class for services such as Grafana and Prometheus"
}

variable "idp_credentials" {
  type = object({
    provider     = string
    enabled      = bool
    clientID     = string
    clientSecret = string
  })

  default = {
    enabled      = false
    clientID     = ""
    clientSecret = ""
    provider     = ""
  }
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_ca_cert  = string
    kubernetes_token    = string
    namespace           = string
  })

  default = {
    kubernetes_endpoint = ""
    kubernetes_ca_cert  = ""
    kubernetes_token    = ""
    namespace           = "monitoring"
  }

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}