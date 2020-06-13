resource "gitlab_deploy_token" "gitlab_group_k8s_token" {
  count = var.enabled ? 1 : 0

  group      = var.gitlab_group_id
  name       = "Will be used in order to provide access to Gitlab Docker Registry from Kubernetes"
  username   = var.docker_username
  expires_at = timeadd(timestamp(), "8640h") // 1 year

  lifecycle {
    ignore_changes = [
      expires_at
    ]
  }

  scopes = ["read_registry"]
}

# GitLab Deploy Tokens are created for internal and private projects when Auto DevOps is enabled,
# and the Auto DevOps settings are saved. You can use a Deploy Token for permanent access to the registry.
#
# CI_REGISTRY_PASSWORD is only valid during deployment. 
# Kubernetes will be able to successfully pull the container image during deployment, 
# but if the image must be pulled again, such as after pod eviction, 
# Kubernetes will fail to do so as it attempts to fetch the image using CI_REGISTRY_PASSWORD.
# 
# - https://docs.gitlab.com/ee/topics/autodevops/stages.html#gitlab-deploy-tokens
# - https://gitlab.com/gitlab-org/cluster-integration/auto-deploy-image/-/blob/46fb2b4774459d7dc2419f552e64407d73c803ce/src/bin/auto-deploy#L90
resource "gitlab_group_variable" "ci_deploy_user" {
  count = var.enabled ? 1 : 0

  group     = var.gitlab_group_id
  key       = "CI_DEPLOY_USER"
  value     = var.docker_username
  protected = true
  masked    = false
}

resource "gitlab_group_variable" "ci_deploy_password" {
  count = var.enabled ? 1 : 0

  group     = var.gitlab_group_id
  key       = "CI_DEPLOY_PASSWORD"
  value     = gitlab_deploy_token.gitlab_group_k8s_token.0.token
  protected = true
  masked    = true
}

resource "kubernetes_secret" "docker_pull_secret" {
  count = var.enabled && var.k8s_secret_enabled ? 1 : 0

  metadata {
    name      = "gitlab-registry" // due to GitLab's AutoDevOps Helm chart default settings
    namespace = "default"
  }

  data = {
    ".dockerconfigjson" = templatefile("${path.module}/config.json.tpl", {
      username = var.docker_username,
      password = gitlab_deploy_token.gitlab_group_k8s_token.0.token
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [gitlab_deploy_token.gitlab_group_k8s_token]
}

output "k8s_deploy_token" {
  value     = join("", gitlab_deploy_token.gitlab_group_k8s_token.*.token)
  sensitive = true
  depends_on = [
    gitlab_deploy_token.gitlab_group_k8s_token
  ]
}
