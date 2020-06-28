# Rancher Server on DigitalOcean Kubernetes / Scaleway Kapsule 

Intended for experimentation/evaluation with Rancher Server, learn Rancher before you will decide to set up Rancher within your team for production requirements.

*Official Note from rancher.com:* The Rancher management server can only be run on Kubernetes cluster in an infrastructure provider where Kubernetes is installed using K3s or RKE. Use of Rancher on hosted Kubernetes providers, such as EKS, is not supported.

Rancher Service can be installed on managed Kubernetes, but not will be covered by any SLA and is not being recommended.

**You will be responsible for any and all infrastructure costs incurred by these resources.**

This module will create:
- Kong Ingress Contoller (responsible to route traffic to Rancher, will be created Load Balancer then the IP of LB will be used to create an A dns record with your domain)
- External DNS (responsible to setup DNS records for your internet-faced services, in our case it's Rancher server, for instance *rancher.scaleway-rancher-example.lazyorange.xyz*)
- Rancher Server 2.4.3 (by using helm 3)

### Requirements

- [Scaleway Account](https://www.scaleway.com/en/) If you want to run Kubernetes on Scaleway, preffered way. You will be charged for one node DEV1-M [€7.99/month](https://www.scaleway.com/en/pricing/#virtual-instances) within you cluster, one load balancer [€8.99/month](https://www.scaleway.com/en/pricing/#load-balancer), the control plane is [free](https://www.scaleway.com/en/pricing/#kubernetes-kapsule)
- [Cloudflare Account](https://www.cloudflare.com) You need to provide CloudFlare token to use with ExternalDNS, can be skipped, but you will have to setup DNS record within your DNS provider to reach out rancher server

or 

- [DigitalOcean Account](https://m.do.co/c/cab44dbb5640) If you want to run Kubernetes on Digital Ocean (**You can support this project by using my referral link**)
- [Terraform](https://www.terraform.io/downloads.html) (v0.12.13+)

## Optional

- [doctl](https://github.com/digitalocean/doctl#installing-doctl) In order to fetch kubeconfig
- [helm3](https://helm.sh/docs/intro/install/) In order to verify that all helm releases have been installed as expected
- [Visual Studio Code](https://code.visualstudio.com/) You will be able to use [Dev Container](https://code.visualstudio.com/docs/remote/containers) with preinstalled tools.

If you don't want install all these tools you can open this repo from VS Code by using [Dev Container](https://code.visualstudio.com/docs/remote/containers). All this stuff is being developed by using VS Code inside Dev Container.

## Installation and setup

1.1 Setup [Scaleway credentials](docs/how-to-obtain-scaleway-credentials.md) (skip if you are not going to use Scaleway within this example).
In the result these env variables **must be** presented.

```bash
export SCW_ACCESS_KEY="<your_access_key>"
export SCW_SECRET_KEY="<your_secret_key>"
export SCW_DEFAULT_ORGANIZATION_ID="<your_organization_id>"
export SCW_DEFAULT_ZONE=fr-par-1
export SCW_DEFAULT_REGION=fr-par

export TF_VAR_domain="your_domain_name"
export TF_VAR_rancher_password="mah1zuxoh0uPhu8pinahZ"
```

1.2. Create CloudFlare access token as decribed [here](docs/how-to-obtain-cloudflare-credentials.md):
```bash
export TF_VAR_cf_token="your_claudflare_token"
```

2. Init and apply terraform config:
```bash
terraform init
terraform apply -auto-approve
```

Output:
```bash
module.scaleway.scaleway_k8s_cluster_beta.default[0]: Refreshing state... [id=fr-par/a985f912-466e-4c74-9396-a06e5d50d018]
module.scaleway.scaleway_k8s_pool_beta.main[0]: Refreshing state... [id=fr-par/5a5cd059-3450-485e-8b09-6cfb3f8d4853]
local_file.scalewey_k8s_config: Refreshing state... [id=f09186c33f7b494b638854780d280d3e2fd30eea]
module.rancher_server.helm_release.rancher_server[0]: Refreshing state... [id=rancher-server]
module.ingress_stack.module.cert_manager.helm_release.cert_manager[0]: Refreshing state... [id=cert-manager]
module.ingress_stack.module.external_dns.helm_release.external_dns[0]: Refreshing state... [id=external-dns]
module.ingress_stack.module.kong.helm_release.kong_crd[0]: Refreshing state... [id=kong-crd]
module.ingress_stack.module.kong.helm_release.kong[0]: Refreshing state... [id=kong]
null_resource.wait_for_rancher[0]: Refreshing state... [id=4289394455923760366]
rancher2_bootstrap.admin[0]: Refreshing state... [id=user-9wmql]
module.ingress_stack.module.cert_manager.helm_release.cert_manager_issuers[0]: Refreshing state... [id=cert-manager-issuers]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

rancher_password = <sensitive>
rancher_url = https://rancher.scaleway-rancher-example.lazyorange.xyz
rancher_username = admin
```

3. Retrieve the admin password for rancher admin dashboard:

```bash
terraform output rancher_password
```

Output:
```bash
your_password
```

That's all, let's go to Rancher Admin Dashboard to learn rancher!