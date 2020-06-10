variable "enabled" {
  type = bool
  default = false
}

variable "gitlab_group_id" {
  type = string
}

variable "docker_username" {
  type        = string
  description = "(Optional) A docker username, used as username for created deploy token"
  default     = "gitlab-registry"
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  description = "Credentials for Kubernetes which will be used by Kubernetes provider"
}