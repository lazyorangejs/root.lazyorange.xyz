locals {
  s3_bucket_name   = replace("${local.domain}-${local.stage}", ".", "-")
}

module "do_backend" {
  source  = "../terraform/cloud/do-backend"

  bucket_name = local.s3_bucket_name
}

output "terraform_backend_config" {
  value = module.do_backend.terraform_backend_config
}