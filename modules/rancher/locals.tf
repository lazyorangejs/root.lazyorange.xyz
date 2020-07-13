locals {
  rancher_enabled = var.enabled ? 1 : 0
  rancher_version = var.rancher_version

  letsEncryptEnabled = var.letsEncrypt.enabled
  letsEncryptEmail   = local.letsEncryptEnabled ? var.letsEncrypt.email : ""
}
