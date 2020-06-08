# https://github.com/Kong/charts/blob/master/charts/kong/requirements.yaml
# https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "kong_postgresql" {
  count = local.pg_k8s_enabled ? 1 : 0

  name       = "kong-postgresql"
  repository = "https://charts.bitnami.com/bitnami"

  chart   = "postgresql"
  version = "8.6.8"

  atomic          = true
  cleanup_on_fail = true
  skip_crds       = true
  create_namespace = true

  namespace = var.kubernetes.namespace

  values = []

  set {
    name  = "postgresqlUsername"
    value = local.db.pg_user
  }

  set {
    name = "postgresqlPassword"
    value = local.db.pg_password
  }

  set {
    name  = "postgresqlDatabase"
    value = local.db.pg_database
  }

  depends_on = []
}
