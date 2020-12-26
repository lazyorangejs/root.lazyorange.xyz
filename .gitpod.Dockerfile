FROM registry.gitlab.com/lazyorangejs/infra/root.lazyorange.xyz:terraform-v0.12.25-helmfile-v0.116.0-doctl-1.43.0-kubectl-v1.16.0-helm-v3.2.1-gitpod-rc.1

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

# ==> Install zsh, direnv (it's not required by Gitlab Pipelines)
RUN apt-get install direnv zsh -yq && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  \
    && echo 'eval "$(direnv hook zsh)"' >> $HOME/.zshrc \
    && curl -sL https://howtowhale.github.io/dvm/downloads/latest/install.sh | sh \
    && echo 'source $HOME/.dvm/dvm.sh && dvm detect' >> $HOME/.zshrc \
    && echo '[[ -r $DVM_DIR/bash_completion ]] && . $DVM_DIR/bash_completion' >> $HOME/.zshrc
