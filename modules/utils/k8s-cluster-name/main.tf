variable "gitlab_project_id" {
  type        = string
  default     = ""
  description = "(Semi-optional, string) The id of the project to add the cluster to."
}

variable "gitlab_group_id" {
  type        = string
  description = "(Semi-optional, string) The id of the group to add the cluster to."
  default     = ""
}

resource "random_pet" "k8s_cluster_name" {}

data "gitlab_group" "this" {
  count = length(var.gitlab_group_id) > 0 ? 1 : 0

  group_id = var.gitlab_group_id
}

output "name" {
  value = length(var.gitlab_group_id) > 0 ? replace("${data.gitlab_group.this.0.full_path}", "/", "-") : random_pet.k8s_cluster_name.id
}