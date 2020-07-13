variable "gitlab_token" {
  type = string
}

variable "do_token" {
  type = string
}

variable "cf_token" {
  type        = string
  default     = ""
  description = "(Optional) A cloudflare token, will be used to setup DNS records by using ExternalDNS"
}

variable "idp_creds" {
  type = object({
    provider     = string
    clientID     = string
    clientSecret = string
  })
  default     = { provider = "", clientID = "", clientSecret = "" }
  description = "(Optional) Identity Provider client ID and client secret will be used to restict access to infra components such Elastic Kibana, Prometheus, Grafana, etc"
}