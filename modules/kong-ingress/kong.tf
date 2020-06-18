locals {
  enabled = var.enabled ? 1 : 0
  version = "1.5.0"

  pg_k8s_enabled = var.enabled && var.pg_k8s_enabled && length(var.pg_creds.pg_host) == 0

  # https://docs.konghq.com/2.0.x/configuration/#postgres-settings
  db = local.pg_k8s_enabled ? merge(var.pg_creds, {
    enabled     = true
    pg_host     = "kong-postgresql"
    pg_user     = "kong"
    pg_password = "kong_password"
    pg_database = "kong"
  }) : var.pg_creds
}

resource "helm_release" "kong_crd" {
  count = local.enabled

  name  = "kong-crd"
  chart = pathexpand("${path.module}/chart")

  atomic           = true
  create_namespace = true

  namespace        = var.kubernetes.namespace
}

# https://charts.konghq.com/
# https://github.com/Kong/charts/blob/master/charts/kong/README.md
# https://github.com/Kong/charts/blob/master/charts/kong/values.yaml
resource "helm_release" "kong" {
  count = local.enabled

  name       = "kong"
  repository = "https://charts.konghq.com"

  chart   = "kong"
  version = local.version

  atomic           = false
  cleanup_on_fail  = false

  create_namespace = true
  skip_crds        = true
  namespace        = var.kubernetes.namespace

  values = [
    templatefile("${path.module}/values.yaml", {}),
    local.db.enabled ? templatefile("${path.module}/pg-values.yaml", local.db) : ""
  ]

  set {
    name  = "image.tag"
    value = "2.0"
  }

  set {
    name  = "admin.enabled"
    value = "true"
  }

  set {
    name  = "ingressController.installCRDs"
    value = "false"
  }

  depends_on = [
    helm_release.kong_crd
  ]
}
