# Fixing Terraform State

### Summary

- **Cause**: I refactored how certificates were configured. So the old state bindings are no longer accurrate.
- **Symptom**: Terraform is trying to delete/re-create resources that already exist and throws errors. 
- **Fix**: The resources exist. We just need to fix the bindings.

Example error message

```
│ Error: A resource with the ID "https://cloudkube-staging-kv.vault.azure.net/certificates/wildcard-staging-cloudkube/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_key_vault_certificate" for more information.
│
│   with module.cloudkube.azurerm_key_vault_certificate.certs["staging-wildcard-staging-cloudkube"],
│   on modules/shared-infra/key-vault-certificates.tf line 44, in resource "azurerm_key_vault_certificate" "certs":
│   44: resource "azurerm_key_vault_certificate" "certs" {
│
```

## How to Fix

First remove the old bindings, for example [`tls_root_certs`](https://github.com/julie-ng/cloudkube-shared-infra/blob/5687c39af5e36c19d6e2a1d39c67d921cbd0840e/modules/shared-infra/tls.tf#L29) from the old state, e.g. `5687c39`.


```bash
terraform state rm 'module.cloudkube.azurerm_key_vault_certificate.tls_root_certs'
terraform state rm 'module.cloudkube.azurerm_key_vault_certificate.tls_wildcard_certs'
```

If you don't know the binding, first run

```
terraform state list
```

### Option 1 - Re-deloy

The easiest way is just to re-deploy…

```bash
terraform plan 
terraform apply
```

> [!WARNING]
> But re-deploying might also "recreate" a resource, which can cause downtime for production applications.

### Option 2 - Import (better)

It's better to just reference something that already exists, for example

```bash
terraform import azurerm_key_vault_certificate.example "https://example-keyvault.vault.azure.net/certificates/example/fdf067c93bbb4b22bff4d8b7a9a56217"
```

The provider docs have an "Import" section that describes the format. In the example above, the `resource id` is used as a reference.

### Option 3 - Move (better)

Also better than re-deploy. But might be trickier to figure out the references.

Basic example

```bash
terraform state mv azurerm_container_registry.acr module.cloudkube.azurerm_container_registry.acr
```

Example with `map`s that require single quotes `'` to be interpreted as separate params in bash/shell.

```bash
terraform state mv 'azurerm_key_vault.vaults["prod"]' 'module.cloudkube.azurerm_key_vault.vaults["prod"]'
```

## References 

- [For expressions](https://developer.hashicorp.com/terraform/language/expressions/for), e.g. `[for s in var.list: … ]`
- Meta arguments
  - [`for_each`](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
  - [`lifecycle`](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
  - [`depends_on`](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

#### State

- [Moving resources overview](https://developer.hashicorp.com/terraform/cli/state/move), incl.
  - `terraform state mv`
  - `terraform state rm`
- [Inspecting state](https://developer.hashicorp.com/terraform/cli/state/inspect), incl.
  - `terraform state list`
  - `terraform state show`
