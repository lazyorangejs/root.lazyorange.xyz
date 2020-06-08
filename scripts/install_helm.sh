#!/bin/bash

# Releases:
# - https://github.com/helm/helm/releases
export HELM_VERSION=${HELM_VER:-"v3.2.1"}

rm -rf /tmp/helm
mkdir -p /tmp/helm

cd /tmp/helm

wget https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz
tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm

rm -rf /tmp/helm

helm version -c