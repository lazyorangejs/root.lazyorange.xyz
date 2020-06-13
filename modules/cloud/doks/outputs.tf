output "cluster_id" {
  value = digitalocean_kubernetes_cluster.default.name
}

output "kubernetes" {
  value = {
    k8s_provider = "digitalocean"

    kubernetes_endpoint = digitalocean_kubernetes_cluster.default.endpoint
    kubernetes_token    = digitalocean_kubernetes_cluster.default.kube_config[0].token
    kubernetes_ca_cert  = digitalocean_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate
  }
}
