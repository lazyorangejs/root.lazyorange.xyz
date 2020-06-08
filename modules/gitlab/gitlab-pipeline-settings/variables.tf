variable "gitlab_project_id" {
  type        = string
  description = "An unique identifier of the project."
}

# it doesn't work correctly, see the example of this issue here
# https://gitlab.com/koyfin/backend/live-data-transformer/-/jobs/532008325
# https://forum.gitlab.com/t/error-from-server-notfound-deployments-extensions-not-found/29301/3
variable "rollout_status_disabled" {
  type    = bool
  default = true
}

variable "performance_disabled" {
  type    = bool
  default = false
}

variable "test_disabled" {
  type    = bool
  default = false
}

variable "review_disabled" {
  type    = bool
  default = false
}

# https://docs.gitlab.com/ee/topics/autodevops/customize.html#using-external-postgresql-database-providers
variable "postgres_enabled" {
  type        = bool
  default     = false
  description = ""
}

variable "staging_enabled" {
  type        = bool
  default     = false
  description = ""
}

variable "development_enabled" {
  type        = bool
  default     = true
  description = ""
}

variable "code_quality_disabled" {
  type        = bool
  default     = true
  description = ""
}

# References:
# - https://gitlab.com/gitlab-org/cluster-integration/auto-deploy-image/-/blob/master/src/bin/auto-deploy#L401
variable "replicas" {
  type    = string
  default = "2"
}
