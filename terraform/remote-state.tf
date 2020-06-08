terraform {
  backend "s3" {
    endpoint = "nyc3.digitaloceanspaces.com"

    key    = "terraform.tfstate"
    bucket = "lab-lazyorange-xyz-sandbox"
    region = "us-west-1"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}
