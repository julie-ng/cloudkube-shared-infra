# Azure Key Vault

N.B. This assumes you have `Key Vault Administrator` priviledged role assigned at subscription level. So it's not assigned here.

### Data Resources

i.e. dependencies

* Shared Resource Group
* Managed Identities

### Managed Resources

* Azure Key Vault
* Role Assignments
  * `Key Vault Secret User` - a read-only role for AKS cluster identities  
* TLS Certificates