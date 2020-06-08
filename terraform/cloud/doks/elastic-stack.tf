data "digitalocean_sizes" "elastic_stack" {
  filter {
    key    = "vcpus"
    values = [2]
  }

  filter {
    key    = "memory"
    values = [8192, 12288]
  }

  filter {
    key    = "regions"
    values = [var.region]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

# - https://docs.gitlab.com/ee/user/clusters/applications.html#elastic-stack
resource "digitalocean_kubernetes_node_pool" "elastic_stack" {
  count = var.elastic_stack_enabled ? 1 : 0

  cluster_id = digitalocean_kubernetes_cluster.default.id

  name = "elastic-stack"
  // size       = element(data.digitalocean_sizes.elastic_stack.sizes, 0).slug
  # https://slugs.do-api.dev/
  // size       = "s-2vcpu-4gb"
  size       = "s-4vcpu-8gb"
  auto_scale = true
  node_count = 1
  min_nodes  = 1
  max_nodes  = 5

  tags       = ["infra", "elastic-stack"]

  labels = {
    service  = "elastic-stack"
    tier     = "logging"
    priority = "high"
  }
}