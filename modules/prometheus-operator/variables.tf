variable "enabled" {
  type    = bool
  default = true
}

variable "grafana_url" {
  type = string
  default = ""
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