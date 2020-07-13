resource "gitlab_project_variable" "this" {
  project = var.gitlab_project_id

  for_each = {
    TF_VAR_gitlab_token = var.gitlab_token
    TF_VAR_do_token     = var.do_token

    AWS_ACCESS_KEY_ID     = var.s3_aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.s3_aws_secret_access_key

    SCW_ACCESS_KEY              = ""
    SCW_SECRET_KEY              = ""
    SCW_DEFAULT_ORGANIZATION_ID = ""
  }

  protected         = true
  environment_scope = "*"

  key   = each.key
  value = each.value
}
