FROM registry.gitlab.com/lazyorangejs/infra/root.lazyorange.xyz:terraform-v0.12.25-helmfile-v0.116.0-doctl-1.43.0-kubectl-v1.16.0-helm-v3.2.1

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
