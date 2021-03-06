FROM bitnami/minideb:stretch
# FROM ubuntu:20.04

RUN apt-get update && apt-get install -qy wget unzip curl git procps

COPY scripts /scripts

ARG kubectl_ver=v1.16.0
ENV KUBECTL_VERSION $kubectl_ver
RUN /scripts/install_kubectl.sh

# ==> Install Helm
ARG helm_ver=v3.2.0
ENV HELM_VER $helm_ver
RUN /scripts/install_helm.sh

# ==> Install Terraform
ARG terraform_ver=0.12.25
ENV TERRAFORM_VERSION $terraform_ver

RUN curl -LO https://raw.github.com/robertpeteuil/terraform-installer/master/terraform-install.sh && chmod +x terraform-install.sh
RUN ./terraform-install.sh -i $TERRAFORM_VERSION
# Check that it's installed
RUN terraform --version 

# ==> Install Helmfile
ARG helmfile_ver=v0.116.0
ENV HELMFILE_VERSION $helmfile_ver
RUN /scripts/install_helmfile.sh

# ==> Install AWS cli 
# It increases image size from 393MB to 778MB
# and as a result increases the bootstrap process of Gitlab CI job
RUN apt-get install python python-pip -qy
RUN pip install awscli

# ==> Install doctl
ARG doctl_ver=1.43.0
ENV DOCTL_VERSION $doctl_ver
RUN ./scripts/install_doctl.sh

# ==> Install jq
ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq && jq --version

# ==> Install zsh, direnv (not required by Gitlab Pipelines)
# move to separate dockerfile
RUN apt-get install direnv zsh -yq && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  \
    && echo 'eval "$(direnv hook zsh)"' >> $HOME/.zshrc \
    && curl -sL https://howtowhale.github.io/dvm/downloads/latest/install.sh | sh \
    && echo 'source /root/.dvm/dvm.sh && dvm detect' >> $HOME/.zshrc \
    && echo '[[ -r $DVM_DIR/bash_completion ]] && . $DVM_DIR/bash_completion' >> $HOME/.zshrc

# ==> Install Packer (https://packer.io/) (not required by Gitlab Pipelines)
ARG packer_ver=1.5.1
ENV PACKER_VER $packer_ver
RUN /scripts/install_packer.sh

RUN apt-get remove -qy wget unzip python-pip && apt-get clean