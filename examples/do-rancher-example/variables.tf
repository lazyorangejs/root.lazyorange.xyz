variable "do_token" {
  type = string
}

variable "cf_token" {
  type        = string
  default     = ""
  description = "(Optional) A cloudflare token, will be used to setup DNS records by using ExternalDNS"
}

variable "rancher_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Rancher will be installed when DO Kubernetes cluster is up and running"
}

variable "rancher_password" {
  type        = string
  description = "(Required/sensitive) Password for Admin user"
}
