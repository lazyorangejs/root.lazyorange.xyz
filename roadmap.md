# Project Roadmap

## Overview

### v.0.0.x Basic Scenario

- [x] Setup developer-friendly environment to deploy Kubernetes from Gitlab CI and connect to Gitlab group 
- [x] Configure a terraform state storage (DigitalOcean Spaces) for infrastructure resources
- [x] Deploy a Kubernetes in DigitalOcean by using DOKS
- [x] Provision Kubernetes with addons: Kong Ingress Contoller, Load Balancer, Cert-Manager, ExternalDNS
- [x] Setup Kubernetes Node Groups to deploy Elastic Stack (ElasticAPM, Elasticsearch, Filebeat)
- [x] Setup Rancher by using [LetsEncrypt HTTP-01 challenge](https://cert-manager.io/docs/configuration/acme/http01/) as a provisioner for certificates (for public infrastucture)
- [x] Setup [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy) to provide authentication for Kubernetes Ingress resources such as Grafana, Prometheus, etc by using Gitlab application
- [x] Setup Kubernetes Docker Registry Secrets into CI/CD env variables for Gitlab's Auto Deploy Job

### v0.0.1

- [ ] Configure Prometheus Operator, Graphana Dashboards, etc
- [ ] Create a sentry terraform module to setup and configure a sentry project per GitLab project

### Backlog

- [ ] Setup Kubernetes Docker Registry Secrets for developers to play with Gitlab Docker registry
- [ ] Setup Gitlab Runner node group to use Gitlab Runners inside Kubernetes
- [ ] Setup [Elastic Uptime Monitoring](https://www.elastic.co/uptime-monitoring)
- [ ] Setup [IngressMonitor Controller](https://github.com/stakater/IngressMonitorController)

Reffrences:

- <https://github.com/oauth2-proxy/oauth2-proxy>
- <https://github.com/helm/charts/tree/master/stable/oauth2-proxy>
- <https://github.com/nokia/kong-oidc>
