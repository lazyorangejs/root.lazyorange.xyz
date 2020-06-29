#!/bin/bash

export WORKDIR=/tmp/terraform-provider-rke

rm -rf $WORKDIR && mkdir -p $WORKDIR && cd $WORKDIR

curl -LO https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-linux-amd64.tar.gz && \
  tar -xzvf terraform-provider-rke-linux-amd64.tar.gz && \
  chmod +x ./terraform-provider-rke-9c95410/terraform-provider-rke && \
  mkdir -p ~/.terraform.d/plugins/linux_amd64/ && \
  mv ./terraform-provider-rke-9c95410/terraform-provider-rke ~/.terraform.d/plugins/linux_amd64/terraform-provider-rke_v1.0.0
  rm -rf ./terraform-provider-rke-*