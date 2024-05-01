# Key Vault Defaults
key_vault_sku                        = "standard"
key_vault_enable_rbac_authorization  = true
key_vault_purge_protection_enabled   = false # so we can fully delete it
key_vault_soft_delete_retention_days = 7     # minimum

# Names of the 3 key vault resources to create
key_vault_names = {
  dev     = "cloudkube-dev-kv"
  staging = "cloudkube-staging-kv"
  prod    = "cloudkube-prod-kv"
}
