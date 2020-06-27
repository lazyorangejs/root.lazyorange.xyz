variable "domain" {
  type        = string
  description = "(Required) A domain name, for instance rancher-example.lazyorange.xyz"
}

variable "do_token" {
  type        = string
  default     = ""
  description = "(Optional) A digital ocean token, will be used to create Kubernetes cluster, setup DNS records by using ExternalDNS"
}

variable "cf_token" {
  type        = string
  default     = ""
  description = "(Optional) A cloudflare token, will be used to setup DNS records by using ExternalDNS"
}

variable "rancher_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Rancher will be installed when DO Kubernetes cluster is up and running"
}

variable "rancher_password" {
  type        = string
  description = "(Required/sensitive) Password for Admin user"
}
