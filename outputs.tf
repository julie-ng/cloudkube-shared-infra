output "storage_account" {
  value = {
    name                  = azurerm_storage_account.cloudkube.name
    primary_blob_endpoint = azurerm_storage_account.cloudkube.primary_blob_endpoint
  }
}

output "DNS" {
  value = module.dns
}

output "key_vaults" {
  value = module.key_vaults
}

output "github_identities" {
  value = module.github_identities
}

output "container_registry" {
  value = module.container_registry
}
