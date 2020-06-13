terraform {
  required_version = "~> 0.12.3"

  required_providers {
    scaleway = "~> 1.15"
  }
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
}