init:
	terraform init -backend-config=backends/azure.conf.hcl

reconfigure:
	terraform init -backend-config=backends/azure.conf.hcl -reconfigure -upgrade

plan:
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan