locals {
  kubernetes   = merge({ namespace = "logging" }, var.kubernetes)
  cluster_file = "${abspath(path.root)}/cluster.yaml"
  cluster      = yamldecode(fileexists(local.cluster_file) ? file(local.cluster_file) : file("${path.module}/settings.yml")).cluster

  settings = merge({
    elastic_stack = { enabled = false },
    kibana_url    = format("kibana.%s", var.domain),
    #
    apm            = { enabled = false },
    apm_server_url = format("apm.%s", var.domain)
  }, local.cluster.stacks.logging)
}