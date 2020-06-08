#!/bin/bash

export TERRAFORM_DIR=./terraform

echo '' > $TERRAFORM_DIR/remote-state.tf

terraform init -input=false $TERRAFORM_DIR
terraform apply -input=false -auto-approve -target=module.do_backend $TERRAFORM_DIR
terraform output terraform_backend_config > $TERRAFORM_DIR/remote-state.tf

terraform init $TERRAFORM_DIR