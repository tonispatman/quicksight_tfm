TF ?= terraform
TFVARS ?= terraform.tfvars

init:
	$(TF) init

plan:
	$(TF) plan -var-file=$(TFVARS)

apply:
	$(TF) apply -auto-approve -var-file=$(TFVARS)

destroy:
	$(TF) destroy -auto-approve -var-file=$(TFVARS)

fmt:
	$(TF) fmt -recursive
