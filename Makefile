init:
	terraform init -backend-config=backends/azure.conf.hcl

plan:
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan