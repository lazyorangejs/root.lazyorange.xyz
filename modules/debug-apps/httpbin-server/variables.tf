variable "enabled" {
  type    = bool
  default = true
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "ingress_class" {
  type = string
}

variable "service_url" {
  type = string
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}