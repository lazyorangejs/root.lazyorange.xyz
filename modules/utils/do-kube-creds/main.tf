variable "kube_cluster_name" {
  type = string
}

variable "kube_cluster_id" {
  type    = string
  default = ""
}

data "digitalocean_kubernetes_cluster" "default" {
  // there is terraform hack to avoid triggering this data source until k8s will be created
  name = length(var.kube_cluster_id) > 0 ? var.kube_cluster_name : var.kube_cluster_name
}

output "kubernetes" {
  value = {
    k8s_provider = "digitalocean"

    kubernetes_endpoint = data.digitalocean_kubernetes_cluster.default.endpoint
    kubernetes_token    = data.digitalocean_kubernetes_cluster.default.kube_config[0].token
    kubernetes_ca_cert  = data.digitalocean_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate
  }

  description = "Credentials for Kubernetes which can be used by Kubernetes and Helm providers"
}