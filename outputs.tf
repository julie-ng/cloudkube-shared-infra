output "summary" {
  value = {
    resource_group = {
      name     = azurerm_resource_group.shared_rg.name
      location = azurerm_resource_group.shared_rg.location
    }
    key_vault = {
      name = azurerm_key_vault.kv.name
      id   = azurerm_key_vault.kv.id
      uri  = azurerm_key_vault.kv.vault_uri
    }
    storage_account = {
      name                  = azurerm_storage_account.storageacct.name
      primary_blob_endpoint = azurerm_storage_account.storageacct.primary_blob_endpoint
    }
    dns_zone = {
      name         = azurerm_dns_zone.onazureio.name
      name_servers = azurerm_dns_zone.onazureio.name_servers
    }
  }
}
