terraform {
  backend "s3" {
    endpoint = "${region}.digitaloceanspaces.com"

    key    = "terraform.tfstate"
    bucket = "${bucket_name}"
    region = "us-west-1"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}