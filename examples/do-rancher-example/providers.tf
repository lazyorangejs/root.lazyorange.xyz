# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = var.do_token
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = local.rancherUrl
  bootstrap = true
}