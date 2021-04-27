# Foundation
location            = "northeurope"
resource_group_name = "cloudkube-shared-rg"
default_tags = {
  public = "true"
  demo   = "true"
  env    = "prod"
  iac    = "terraform"
}

# Azure Container Registry
azure_container_registry_name        = "cloudkubecr"
azure_container_registry_sku         = "Basic"

# Storage Account
storage_account_name                 = "cloudkubestorage"
storage_account_tier                 = "Standard"
storage_account_replication_type     = "GRS"

# Key Vault
key_vault_name                       = "cloudkube-kv"
key_vault_sku                        = "standard"
key_vault_enable_rbac_authorization  = true
key_vault_purge_protection_enabled   = false # so we can fully delete it
key_vault_soft_delete_retention_days = 7     # minimum

# TLS
tls_certificates = {
  root = {
    name      = "wildcard-cloudkube"
    cert_path = "./certs/combined_star_cloudkube_io.pem"
  }

  dev = {
    name      = "wildcard-dev-cloudkube"
    cert_path = "./certs/combined_star_dev_cloudkube_io.pem"
  }
}
