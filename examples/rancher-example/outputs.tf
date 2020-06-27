output "rancher_url" {
  value      = join("", rancher2_bootstrap.admin.*.url)
  sensitive  = false
  depends_on = [rancher2_bootstrap.admin]
}

# https://www.terraform.io/docs/providers/rancher2/r/bootstrap.html
output "rancher_username" {
  value      = join("", rancher2_bootstrap.admin.*.user)
  sensitive  = false
  depends_on = [rancher2_bootstrap.admin]
}

output "rancher_password" {
  value      = var.rancher_password
  sensitive  = true
  depends_on = [rancher2_bootstrap.admin]
}
