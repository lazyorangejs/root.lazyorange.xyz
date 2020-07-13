variable "enabled" {
  type    = bool
  default = false
}

variable "app_name" {
  type = string
}

variable "ingress_values" {
  type        = string
  default     = ""
  description = "Ingress values encoded as YAML"
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