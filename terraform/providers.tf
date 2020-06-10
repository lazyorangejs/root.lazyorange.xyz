provider "gitlab" {
  token = var.gitlab_token
}

# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.s3_aws_access_key_id
  spaces_secret_key = var.s3_aws_secret_access_key
}

terraform {
  required_version = "~> 0.12.3"

  required_providers {
    gitlab       = "2.10"
    digitalocean = "1.18"
    scaleway     = "1.15"
  }
}