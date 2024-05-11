output "name" {
  value = azurerm_key_vault.kv.name
}

output "resource_group" {
  value = data.azurerm_resource_group.shared_rg.name
}

output "certificates" {
  value = [for c in azurerm_key_vault_certificate.certs : c.id]
}

output "managed_identity_readers" {
  value = { for k, mi in azurerm_role_assignment.readers_on_kv :
    "${k}" => {
      assignment_id = mi.id
      principal_id  = mi.principal_id
      role_name     = mi.role_definition_name
    }
  }
}
