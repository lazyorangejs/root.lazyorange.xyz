resource "random_pet" "gitlab_group_name" {
  length = 3
}

resource "random_pet" "gitlab_project_name" {
  length = 3
}

resource "gitlab_group" "this" {
  name = random_pet.gitlab_group_name.id
  path = random_pet.gitlab_group_name.id
}

resource "gitlab_project" "this" {
  name = random_pet.gitlab_project_name.id

  namespace_id = gitlab_group.this.id
}

output "id" {
  value      = gitlab_group.this.id
  depends_on = [gitlab_group.this]
}

output "infra_project_id" {
  value      = gitlab_project.this.id
  depends_on = [gitlab_project.this]
}
