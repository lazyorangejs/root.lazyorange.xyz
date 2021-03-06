resource "gitlab_project_variable" "default" {
  project = var.gitlab_project_id

  for_each = merge(jsondecode(var.extraEnv.dev), jsondecode(var.extraEnv.global))

  protected         = false
  environment_scope = "*"

  key   = each.key
  value = each.value
}

resource "gitlab_project_variable" "production" {
  project = var.gitlab_project_id

  for_each = var.extraEnv.production

  protected         = true
  environment_scope = "production"

  key   = each.key
  value = each.value
}