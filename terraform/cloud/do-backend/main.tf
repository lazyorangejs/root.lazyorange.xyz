variable "bucket_name" {
  type = string
}

resource "digitalocean_spaces_bucket" "terraform_s3_backend" {
  name = var.bucket_name

  # set to false when the first working version will be ready
  force_destroy = true
}

output "terraform_backend_config" {
  value = templatefile("${path.module}/backend.tf.tpl", {
    region      = digitalocean_spaces_bucket.terraform_s3_backend.region,
    bucket_name = digitalocean_spaces_bucket.terraform_s3_backend.name
  })
}