variable "enabled" {
  type    = bool
  default = false
}

variable "app_name" {
  type = string
}

variable "challengeProvider" {
  type    = string
  default = "http01"
}

variable "ingressClass" {
  type    = string
  default = "nginx"
}

variable "letsEncryptEmail" {
  type    = string
  default = ""
}

variable "do_token" {
  type    = string
  default = ""
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