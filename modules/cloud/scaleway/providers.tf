terraform {
  required_version = "~> 0.12.3"

  required_providers {
    scaleway = "~> 1.15"
  }
}

# Terraform Provider References:
# - https://www.terraform.io/docs/providers/scaleway/index.html
# - https://www.terraform.io/docs/providers/scaleway/index.html#arguments-reference
provider "scaleway" {}