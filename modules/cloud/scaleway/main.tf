variable "enabled" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type        = string
  default     = "1.16.9"
  description = "(Required) The version of the Kubernetes cluster."
}

resource "scaleway_k8s_cluster_beta" "default" {
  count = var.enabled ? 1 : 0

  name             = var.cluster_name
  version          = var.kubernetes_version
  cni              = "calico"
  enable_dashboard = false
  tags             = []

  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "5m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }
}

resource "scaleway_k8s_pool_beta" "main" {
  count = var.enabled ? 1 : 0

  cluster_id          = join("", scaleway_k8s_cluster_beta.default.*.id)
  name                = "main"
  node_type           = "DEV1_M"
  size                = 1
  autoscaling         = true
  autohealing         = true
  min_size            = 1
  max_size            = 15
  wait_for_pool_ready = true
}

output "kubernetes" {
  value = {
    enabled      = var.enabled
    k8s_provider = "scaleway"

    kubernetes_endpoint = length(scaleway_k8s_cluster_beta.default) > 0 ? scaleway_k8s_cluster_beta.default.0.kubeconfig[0].host : ""
    kubernetes_token    = length(scaleway_k8s_cluster_beta.default) > 0 ? scaleway_k8s_cluster_beta.default.0.kubeconfig[0].token : ""
    kubernetes_ca_cert  = length(scaleway_k8s_cluster_beta.default) > 0 ? scaleway_k8s_cluster_beta.default.0.kubeconfig[0].cluster_ca_certificate : ""

    kubeconfig = length(scaleway_k8s_cluster_beta.default) > 0 ? scaleway_k8s_cluster_beta.default.0.kubeconfig[0].config_file : ""
  }

  description = "Credentials for Kubernetes which can be used by Kubernetes and Helm providers"
}