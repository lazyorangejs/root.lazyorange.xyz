# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = var.do_token
}

provider "gitlab" {
  token = var.gitlab_token
}