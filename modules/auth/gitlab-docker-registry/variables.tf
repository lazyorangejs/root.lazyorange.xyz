variable "enabled" {
  type        = bool
  default     = true
  description = "(Optional) Create deploy tokens for AutoDevOps Deploy job"
}

variable "k8s_secret_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Kubernetes Secret with access to GitLab's Docker Registry will be created in the default namespace, useful for testing purposes"
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

  description = "(Required) Credentials for Kubernetes which will be used by Kubernetes provider"
}