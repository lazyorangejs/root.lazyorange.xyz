variable "enabled" {
  type    = bool
  default = true
}

variable "server_url" {
  type    = string
  default = ""
}

variable "ingress_values_file" {
  type        = string
}

variable "helm_values_file" {
  description = "A path to file that contain common values to schedule pod on the right nodes"
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