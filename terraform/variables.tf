variable "kubernetes_version" {
  type        = string
  description = "Digital Ocean often releases bug fixes and does not allow to create Kubeternes cluster with outdated version, so we always should use the latest version, just use version prefix"
  default     = "1.16"
}

variable "gitlab_token" {
  type = string
}

variable "do_token" {
  type    = string
  default = ""
}

variable "root_gitlab_project" {
  type        = string
  default     = ""
  description = "This variable can be populated from Gitlab CI environments"
}

variable "root_gitlab_group_id" {
  type        = string
  description = ""
  default     = ""
}

variable "s3_aws_access_key_id" {
  type        = string
  default     = ""
  description = "AWS Key ID"
}

variable "s3_aws_secret_access_key" {
  type        = string
  default     = ""
  description = "AWS Secret Key"
}

variable "sentry_dsn" {
  type    = string
  default = ""

  description = "Helm chart will be installed by providing a non empty Sentry DSN"
}

variable "idp_creds" {
  type = object({
    clientID     = string
    clientSecret = string
  })
  default     = { clientID = "", clientSecret = "" }
  description = "(Optional) Identity Provider client ID and client secret will be used to restict access to infra components such Elastic Kibana, Prometheus, Grafana, etc"
}

variable "kubernetes" {
  type = object({
    kubernetes_endpoint = string
    kubernetes_token    = string
    kubernetes_ca_cert  = string
  })

  default = {
    kubernetes_endpoint = ""
    kubernetes_token    = ""
    kubernetes_ca_cert  = ""
  }

  description = "Kubernetes credentials which will be used by Kubernetes and Helm providers"
}