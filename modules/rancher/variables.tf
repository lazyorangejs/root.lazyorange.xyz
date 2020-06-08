variable "enabled" {
  type        = bool
  default     = true
  description = "Please note it requires permissions for creating namespaces"
}

variable "hostname" {
  type        = string
  description = "Fully qualified name to reach your Rancher server (https://github.com/rancher/rancher/blob/master/chart/values.yaml#L39)"
}

variable "ingressClass" {
  type    = string
  default = "nginx"
}

variable "ingressTlsSource" {
  type    = string
  default = "letsEncrypt"
}

variable "clusterIssuer" {
  type    = string
  default = "letsencrypt-prod"
}

variable "letsEncrypt" {
  type = object({
    enabled = bool
    email   = string
  })

  default = {
    enabled = true
    email   = ""
  }
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}