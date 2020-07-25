output "i_am_ready" {
  value = true

  depends_on = [
    helm_release.prometheus_operator_crd
  ]
}