### Problem statement

GitLab Deploy Tokens are created for internal and private projects when Auto DevOps is enabled,
and the Auto DevOps settings are saved. 

`CI_REGISTRY_PASSWORD` is only valid during deployment. 
Kubernetes will be able to successfully pull the container image during deployment,  but if the image must be pulled again, such as after pod eviction, 
Kubernetes will fail to do so as it attempts to fetch the image using `CI_REGISTRY_PASSWORD`.

This module creates deploy token credentials for permanent access to the Gitlab's registry and adds `CI_DEPLOY_USER`, `CI_DEPLOY_PASSWORD` variables into [Group-level environment variables](https://docs.gitlab.com/ee/ci/variables/#group-level-environment-variables), thus they will be available 
from each Gitlab CI/CD pipeline within group.

Useful links:
- https://docs.gitlab.com/ee/topics/autodevops/stages.html#gitlab-deploy-tokens
- https://gitlab.com/gitlab-org/cluster-integration/auto-deploy-image/-/blob/46fb2b4774459d7dc2419f552e64407d73c803ce/src/bin/auto-deploy#L90
- https://docs.gitlab.com/ee/ci/variables/#group-level-environment-variables