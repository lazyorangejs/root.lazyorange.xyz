module "pg_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = "lo"
  environment = "dev"
  name        = "nestjs-sequelize-example"
  label_order = ["namespace", "name", "attributes", "environment"]
  attributes  = []
  delimiter   = "-"

  tags = {
    ManagedBy = "Terraform",
  }
}

locals {
  tags = [
    for key in keys(module.pg_label.tags) :
    "${key}:${lookup(module.pg_label.tags, key)}"
  ]
}

# https://www.terraform.io/docs/providers/do/d/projects.html
data "digitalocean_projects" "do_projects" {}

data "digitalocean_projects" "default" {
  filter {
    key = "is_default"
    values = ["true"]
  }
}

data "digitalocean_project" "default" {
  name = length(var.do_project_id) > 0 ? var.do_project_id : element(data.digitalocean_projects.default.projects, 0).name
}

resource "digitalocean_project_resources" "default" {
  project = data.digitalocean_project.default.id

  resources = [
    digitalocean_database_cluster.postgres.urn
  ]
}

# - https://www.terraform.io/docs/providers/do/r/database_cluster.html
resource "digitalocean_database_cluster" "postgres" {
  name    = module.pg_label.id
  engine  = "pg"
  version = "11"

  size   = var.db_size
  region = var.region

  node_count = 1

  tags = local.tags
}

output "database_url" {
  value = {
    private = digitalocean_database_cluster.postgres.private_uri
    public  = digitalocean_database_cluster.postgres.uri
  }

  sensitive   = true
  description = " The full URI for connecting to the DigitalOcean PostgresSQL cluster"
  depends_on = [
    digitalocean_database_cluster.postgres
  ]
}
