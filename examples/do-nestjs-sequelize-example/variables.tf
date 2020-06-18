variable "db_size" {
  type        = string
  default     = "db-s-1vcpu-1gb"
  description = "(Optional) Database Droplet size associated with the cluster (ex. db-s-1vcpu-1gb)."
}

variable "region" {
  type    = string
  default = "fra1"
}

variable "do_project_id" {
  type    = string
  default = "(Optional) A DigitalOcean project associated with an account, if not specified will be used the default project"
}