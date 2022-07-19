# Core
base_name      = "cloudkube"
location       = "northeurope"
shared_rg_name = "cloudkube-shared-rg"

# Suffixes (follows cloudkube naming convention)
dev_suffix     = "nyl9"
staging_suffix = "4ow"

# Tags
default_tags = {
  public = "true"
  demo   = "true"
  env    = "prod"
  iac    = "terraform"
}

# Key Vault Defaults
key_vault_sku                        = "standard"
key_vault_enable_rbac_authorization  = true
key_vault_purge_protection_enabled   = false # so we can fully delete it
key_vault_soft_delete_retention_days = 7     # minimum
