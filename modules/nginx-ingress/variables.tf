variable "enabled" {
  type    = bool
  default = false
}

variable "ingress_class" {
  type        = string
  description = "(Required) name of the ingress class to route through this controller"
}

variable "app_name" {
  type        = string
  default     = "ingress-nginx"
  description = "A release name"
}

variable "helm_values" {
  type        = string
  default     = ""
  description = "A path to file that contain common values to schedule pod on the right nodes (encoded as yaml string)"
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