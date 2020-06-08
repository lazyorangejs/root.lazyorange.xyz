# !!! DON'T USE, IS NOT READY FOR USAGE !!!
# 

provider "keycloak" {
  client_id = "admin-cli"
  username  = "keycloak"
  password  = "keycloak"
  url       = "https://idp.lab.lazyorange.xyz"
}

locals {
  rancher_domain = "rancher.lab.lazyorange.xyz"
  realm_name     = "local"

  first_user = {
    username   = "vymarkov"
    email      = "vymarkov@gmail.com"
    first_name = "Vitaly"
    first_name = "Markov"
  }
}

resource "keycloak_realm" "this" {
  realm   = local.realm_name
  enabled = true
}

# https://gist.github.com/PhilipSchmid/506b33cd74ddef4064d30fba50635c5b
# - https://idp.lab.lazyorange.xyz/auth/realms/local/protocol/saml/descriptor
# - https://mrparkers.github.io/terraform-provider-keycloak/resources/keycloak_saml_client/
resource "keycloak_saml_client" "saml_client" {
  realm_id  = keycloak_realm.this.id
  client_id = "https://${local.rancher_domain}/v1-saml/keycloak/saml/metadata"
  name      = "rancher"

  valid_redirect_uris = [
    "https://${local.rancher_domain}/v1-saml/keycloak/saml/acs"
  ]

  sign_documents            = true
  sign_assertions           = true
  force_post_binding        = false
  include_authn_statement   = false
  client_signature_required = false

  signing_private_key = file("${path.module}/myservice.key")
  signing_certificate = file("${path.module}/myservice.cert")
}

resource "keycloak_user" "user" {
  realm_id = "${keycloak_realm.this.id}"
  username = local.first_user.username
  enabled  = true

  email      = local.first_user.email
  first_name = local.first_user.first_name
  last_name  = local.first_user.first_name
}