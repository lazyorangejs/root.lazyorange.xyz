variable "domain" {
  type = string
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
    namespace           = string
  })

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}

output "settings" {
  value = local.settings
}