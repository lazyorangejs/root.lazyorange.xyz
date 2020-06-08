variable "enabled" {
  type    = bool
  default = true
}

variable "pg_k8s_enabled" {
  type        = bool
  description = "Setup PostgreSQL on Kubernetes, dont use on the production workloads"
  default     = false
}

variable "pg_creds" {
  type = object({
    enabled = bool

    pg_host     = string
    pg_user     = string
    pg_password = string
  })

  default = {
    enabled     = false
    pg_host     = ""
    pg_user     = ""
    pg_password = ""
  }
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
    namespace           = string
  })

  default = {
    kubernetes_endpoint = ""
    kubernetes_token    = ""
    kubernetes_ca_cert  = ""
    namespace           = "ingress-kong"
  }

  description = "Credentials for Kubernetes which will be used by Kubernetes and Helm providers"
}