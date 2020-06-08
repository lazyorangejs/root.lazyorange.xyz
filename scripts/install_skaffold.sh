#!/bin/bash

# https://github.com/GoogleContainerTools/skaffold/releases
export SKAFFOLD_VERSION=${SKAFFOLD_VERSION:-"v1.8.0"}
export WORKDIR=/tmp/skaffold

rm -rf $WORKDIR && mkdir -p $WORKDIR && cd $WORKDIR

curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/$SKAFFOLD_VERSION/skaffold-linux-amd64 && chmod +x skaffold && mv skaffold /usr/local/bin
chmod +x /usr/local/bin/skaffold

rm -rf $WORKDIR

skaffold version