init:
	terraform init -backend-config=azure.conf.hcl

plan:
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan