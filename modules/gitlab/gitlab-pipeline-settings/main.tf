# References:
# - https://docs.gitlab.com/ee/topics/autodevops/customize.html#build-and-deployment
resource "gitlab_project_variable" "default" {
  project = var.gitlab_project_id

  for_each = {
    DEVELOPMENT_ENABLED          = var.development_enabled
    PERFORMANCE_DISABLED         = var.performance_disabled
    CODE_QUALITY_DISABLED        = var.code_quality_disabled
    POSTGRES_ENABLED             = var.postgres_enabled
    LICENSE_MANAGEMENT_DISABLED  = "yes"
    PERFORMANCE_DISABLED         = "yes"
    SAST_DISABLED                = "yes"
    DEPENDENCY_SCANNING_DISABLED = "yes"
    CONTAINER_SCANNING_DISABLED  = "yes"
    DAST_DISABLED                = "yes"
  }

  protected         = false
  environment_scope = "*"

  key   = each.key
  value = each.value
}

resource "gitlab_project_variable" "rollout_status_disabled" {
  count = var.rollout_status_disabled ? 1 : 0

  project = var.gitlab_project_id

  protected         = false
  environment_scope = "*"

  key   = "ROLLOUT_STATUS_DISABLED"
  value = "yes"
}

resource "gitlab_project_variable" "staging_enabled" {
  count = var.staging_enabled ? 1 : 0

  project = var.gitlab_project_id

  protected         = false
  environment_scope = "*"

  key   = "STAGING_ENABLED"
  value = "yes"
}

resource "gitlab_project_variable" "review_disabled" {
  count = var.review_disabled ? 1 : 0

  project = var.gitlab_project_id

  protected         = false
  environment_scope = "*"

  key   = "REVIEW_DISABLED"
  value = "yes"
}

resource "gitlab_project_variable" "test_disabled" {
  count = var.test_disabled ? 1 : 0

  project = var.gitlab_project_id

  protected         = false
  environment_scope = "*"

  key   = "TEST_DISABLED"
  value = "yes"
}