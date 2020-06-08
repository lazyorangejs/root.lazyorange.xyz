locals {
  cluster_name       = var.cluster_name
  kubernetes_version = data.digitalocean_kubernetes_versions.default.latest_version
}

data "digitalocean_kubernetes_versions" "default" {
  version_prefix = var.kubernetes_version
}

data "digitalocean_sizes" "default" {
  filter {
    key    = "memory"
    values = [2048, 3072, 4096]
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

# References:
# - https://github.com/terraform-providers/terraform-provider-digitalocean/
# - https://www.terraform.io/docs/providers/do/r/kubernetes_cluster.html
# - https://www.terraform.io/docs/providers/do/r/kubernetes_node_pool.html
# - https://www.terraform.io/docs/providers/do/r/kubernetes_node_pool.html#argument-reference
#
resource "digitalocean_kubernetes_cluster" "default" {
  region = var.region

  name    = local.cluster_name
  version = local.kubernetes_version

  node_pool {
    name       = "main"
    size       = element(data.digitalocean_sizes.default.sizes, 0).slug
    auto_scale = true
    node_count = 1
    min_nodes  = 1
    max_nodes  = 5
  }

  lifecycle {
    ignore_changes = [node_pool[0].node_count]
  }
}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.default.name
}