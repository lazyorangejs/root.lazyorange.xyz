# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = var.do_token
}

provider "gitlab" {
  token = var.gitlab_token
}

terraform {
  required_version = "~> 0.12.3"

  required_providers {
    local = "1.4"
  }
}