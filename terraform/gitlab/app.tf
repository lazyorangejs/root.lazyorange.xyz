resource "gitlab_project_variable" "cd_settings" {
  project = var.gitlab_project_id

  for_each = {
    TEST_DISABLED                = "yes"
    CODE_QUALITY_DISABLED        = "yes"
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
