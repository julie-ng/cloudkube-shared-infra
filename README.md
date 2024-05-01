# cloudkube.io - Shared Infrastructure

[Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) Infrastructure as Code (IaC) I use to deploy and manage shared resources for cloudkube.io

## How to use

**Notes to self**

First check config

- State file auth: nothing to configure. Uses Azure AD auth.
- Infra: adjust [`terraform.tfvars`](./terraform.tfvars) and `*.auto.tfvars` as needed

Then just run commands

```bash
make init
make plan
make apply
```

or

```bash
terraform init -backend-config=backends/azure.conf.hcl 
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

## Is this Inner Source?

No, because it's just me. This repo does, however, illustrate the concepts of using self-service infra via pull requests on infrastructure as code (IaC).

<img src="./images/shared-rg-v2.svg" alt="Diagram: shared resources (not accurate)">

_**Diagram: shared resources including created and managed by Terraform**_

Note that Role Assignments are managed here because I view them as owned by the Key Vault owner. But the managed identities belong to the AKS clusters and thus in a different Terraform project.

### Disclaimer

This repository open source and my opinionated workflow for my use-case. Before you clone it and try it out yourself, please remember it is…

- *not* an official Microsoft recommendation
- *not* a reference architecture
- *not* a reference implementation

