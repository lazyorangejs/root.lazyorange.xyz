# https://blog.sentry.io/2019/04/17/surface-kubernetes-errors-with-sentry
resource "helm_release" "sentry_kubernetes" {
  count = var.enabled && var.sentry.enabled ? 1 : 0

  name       = "sentry-kubernetes"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com/"
  namespace  = var.kubernetes.namespace

  chart  = "sentry-kubernetes"
  atomic = true
  create_namespace = true

  set_sensitive {
    name  = "sentry.dsn"
    value = var.sentry.dsn
  }
}
