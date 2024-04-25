# cloudkube.io - Shared Infrastructure

[Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) Infrastructure as Code (IaC) I use to deploy and manage shared resources for cloudkube.io

## How to use

**Notes to self**

First check config

- State file auth: nothing to configure. Uses Azure AD auth.
- Infra: adjust [`terraform.tfvars`](./terraform.tfvars) as needed

Then just run commands

```bash
make init
make plan
make apply
```

or

```bash
terraform init -backend-config=azure.conf.hcl 
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

## InnerSource Infrastructure Example 

In real life, you would probably want to separate these repos into distinct domains, e.g. routing vs firewall whitelisting. This repo exists primarily to make my workflow easier.

### Developer Self-Service

Example configuration as code for Inner Sourcing

```hcl
# cname.tfvars

dns_cname_records = {
  nodejs_demo = {
    name   = "nodejs-demo"
    record = "azure-nodejs-demo.azurewebsites.net"
  }
  node_js_demo_dev = {
    name   = "nodejs-demo-dev"
    record = "azure-nodejs-demo-dev.azurewebsites.net"
  }
}
```



You can view [`dns.auto.tfvars`](https://github.com/julie-ng/cloudkube-shared-infra/blob/f58cac5d7be905e90477eb241921f94afa44a161/dns.auto.tfvars) as an example of how to leverage git and Pull Requests to manage changes to shared infrastructure.

Note: link goes back in history. Project as of writing in July 2022 has everything hard coded in main.tf - probably after re-factoring into a module. 

Note to streamline the workflow process, it is important to have very clear instructions to developers on how to make changes that adhere to standards/conventions, which are set by the maintainers of the infrastructure.

#### _Example Instructions_

I recommend also including a shortened version in the source code where developers make changes.

> - Fork this repo to your org/user
> - Add another nested map to `dns_a_records` or `dns_cname_records`
> - Create a pull request to the `queued` branch of this repo
> - Important: 
> 	- Key names MUST be unique
> 	- Do not edit any other files or your PR will be rejected.
> - See Readme for further details

### Further Reading

Practical information about InnerSource in practice.

- [GitLab: What is InnerSource?](https://about.gitlab.com/topics/version-control/what-is-innersource/)
- [Zalando: How to InnerSource](https://opensource.zalando.com/docs/resources/innersource-howto/)
- [InnerSource Commons](https://innersourcecommons.org/)
