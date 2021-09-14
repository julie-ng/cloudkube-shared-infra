# =========
#  Outputs
# =========

output "main" {
  value = module.cloudkube.main
}

output "DNS" {
  value = module.cloudkube.DNS
}

output "key_vaults" {
  value = module.cloudkube.key_vaults
}

output "devops_key_vault" {
  value = {
    name      = azurerm_key_vault.devops.name
    vault_uri = azurerm_key_vault.devops.vault_uri
  }
}

output "tls_certificates" {
  value = module.cloudkube.tls_certificates
}
