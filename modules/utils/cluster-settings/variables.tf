variable "do_token" {
  type    = string
  default = ""
}

variable "cf_token" {
  type    = string
  default = ""
}

variable "gitlab_group_id" {
  type        = string
  description = "(Semi-optional, string) The id of the group to add the cluster to."
  default     = ""
}

variable "root_gitlab_project" {
  type        = string
  description = "(Required) This variable can be populated from Gitlab CI environments"
}

variable "idp_credentials" {
  type = object({
    provider     = string
    clientID     = string
    clientSecret = string
  })

  default = {
    provider     = "gitlab"
    clientID     = ""
    clientSecret = ""
  }
  description = "(Optional) Identity Provider client ID and client secret will be used to restict access to infra components such Elastic Kibana, Prometheus, Grafana, etc"
}
