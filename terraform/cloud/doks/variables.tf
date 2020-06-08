variable "enabled" {
  type    = bool
  default = true
}

variable "domain" {
  type = string
}

variable "region" {
  type        = string
  description = "(Required) DigitalOcean Region"
}

variable "cluster_name" {
  type        = string
  description = "(Required) Cluster Name for DigitalOcean Region"
}

variable "elastic_stack_enabled" {
  type    = bool
  default = false
}

variable "kubernetes_version" {
  type        = string
  description = "(Required) Digital Ocean often releases bug fixes and does not allow to create Kubeternes cluster with outdated version, so we always should use the latest version, just use version prefix"
}