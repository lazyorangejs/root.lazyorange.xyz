variable "enabled" {
  type    = bool
  default = false
}

variable "app_name" {
  type        = string
  default     = "ingress-nginx"
  description = "A release name"
}

variable "helm_values" {
  description = "A path to file that contain common values to schedule pod on the right nodes (encoded as yaml string)"
  type        = string
  default     = ""
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