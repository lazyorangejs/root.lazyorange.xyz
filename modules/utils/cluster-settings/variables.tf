variable "do_token" {
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
