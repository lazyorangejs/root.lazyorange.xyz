variable "do_token" {
  type = string
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
