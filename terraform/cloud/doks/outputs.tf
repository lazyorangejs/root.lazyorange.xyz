module "creds" {
  source = "../../../modules/utils/do-kube-creds"

  kube_cluster_id   = digitalocean_kubernetes_cluster.default.id
  kube_cluster_name = var.cluster_name
}

output "kubernetes" {
  value = module.creds.kubernetes
}
