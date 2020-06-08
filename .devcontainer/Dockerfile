FROM registry.gitlab.com/lazyorangejs/infra/lab.lazyorange.xyz:terraform-v0.12.25-helmfile-v0.116.0-doctl-1.43.0-kubectl-v1.16.0-helm-v3.2.1

RUN apt-get update && apt-get install libncurses5-dev libncursesw5-dev -yq
# https://github.com/ahmetb/kubectl-aliases
RUN curl https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases > $HOME/.kubectl_aliases &&\
  echo '[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases' >> ~/.zshrc

# https://github.com/ahmetb/kubectx
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx &&\
  ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx &&\
  ln -s /opt/kubectx/kubens /usr/local/bin/kubens
