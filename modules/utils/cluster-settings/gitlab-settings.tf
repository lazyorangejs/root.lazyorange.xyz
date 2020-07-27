data "gitlab_group" "this" {
  count = length(local.settings.gitlab.group_id) > 0 ? 1 : 0

  group_id = local.gitlab_group_id
}