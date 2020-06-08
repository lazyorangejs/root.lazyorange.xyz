locals {
  cert_manager_enabled = var.enabled ? 1 : 0
  cert_manager_version = "v0.15.0"
}