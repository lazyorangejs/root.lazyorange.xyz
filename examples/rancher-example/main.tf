# terraform apply -auto-approve

locals {
  letsEncryptEmail = "vymarkov@gmail.com"

  clusterName                  = "rancher-mission-control"
  defaultLetsEncryptIssuerName = "letsencrypt-prod"

  cert_manager_settings = {
    digitalocean = length(var.do_token) > 0 ? "digitalocean-issuer" : local.defaultLetsEncryptIssuerName
  }

  defaultIssuerName = lookup(local.cert_manager_settings, local.cloudProvider, local.defaultLetsEncryptIssuerName)
  rancherHostname   = format("rancher.%s", local.domain)
  rancherUrl        = format("https://%s", local.rancherHostname)
}

module "ingress_stack" {
  source = "../../terraform/ingress-stack"

  kubernetes = local.kubernetes

  domain              = local.domain
  default_issuer_name = local.defaultIssuerName
  do_token            = var.do_token
  cf_token            = var.cf_token

  settings = {
    kong = {
      enabled = true
    }

    cert_manager = {
      enabled          = true
      letsEncryptEmail = local.letsEncryptEmail
    }

    external_dns = {
      enabled      = true
      dns_provider = "digitalocean"
    }

    infra_nginx_ingress = {
      enabled       = true
      ingress_class = "nginx-infra"
    }

    ingress_class = ["nginx-infra"]
  }
}

# Rancher Server v2.4.3 (stable)
#
# You can't remove rancher by removing rancher helm chart.
# - https://rancher.com/docs/rancher/v2.x/en/faq/removing-rancher/#what-if-i-don-t-want-rancher-anymore
# - https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/#important-notes-on-architecture
module "rancher_server" {
  source = "../../modules/rancher"

  enabled    = var.rancher_enabled
  kubernetes = local.kubernetes

  # https://rancher.com/docs/rancher/v2.x/en/installation/options/chart-options/#common-options
  # letsEncrypt = {
  #   enabled = false
  #   email   = local.letsEncryptEmail
  # }

  ingressClass     = "kong"
  ingressTlsSource = "secret"
  add_local        = true
  clusterIssuer    = local.defaultIssuerName
  hostname         = local.rancherHostname
}

resource "null_resource" "wait_for_rancher" {
  count = var.rancher_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_HOSTNAME}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF
    environment = {
      FOO              = module.rancher_server.i_am_ready
      RANCHER_HOSTNAME = local.rancherHostname
    }
  }
}

resource "rancher2_bootstrap" "admin" {
  count = var.rancher_enabled ? 1 : 0

  provider = rancher2.bootstrap
  password = var.rancher_password

  telemetry = false

  depends_on = [null_resource.wait_for_rancher]
}