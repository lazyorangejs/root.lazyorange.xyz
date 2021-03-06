#!/bin/bash

# https://github.com/digitalocean/doctl/releases
export DOCTL_VERSION="${DOCTL_VERSION:-1.43.0}"

curl -sL https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VERSION/doctl-$DOCTL_VERSION-linux-amd64.tar.gz | tar -xzv
mv ./doctl /usr/local/bin

doctl version