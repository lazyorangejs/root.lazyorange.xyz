locals {
  domain        = var.domain
  cloudProvider = "scaleway"
  kubernetes    = module.scaleway.kubernetes
}

module "scaleway" {
  source  = "../../modules/cloud/scaleway"
  enabled = true

  kubernetes_version = "1.16.9"
  cluster_name       = local.clusterName
}

resource "local_file" "scalewey_k8s_config" {
  sensitive_content = module.scaleway.kubernetes.kubeconfig
  filename          = "${path.module}/.kube/config"
}