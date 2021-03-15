location            = "centralus"
resource_group_name = "onazureio-shared-rg"
default_tags = {
  public = "true"
  demo   = "true"
  env    = "prod"
  iac    = "terraform"
}

# DNS
dns_zone_name = "onazure.io"

# Azure Container Registry
azure_container_registry_name = "onazureiocr"
azure_container_registry_sku  = "Basic"

# Storage Account
storage_account_name             = "onazureiostorage"
storage_account_tier             = "Standard"
storage_account_replication_type = "GRS"

# Key Vault
key_vault_name                       = "onazureio-kv"
key_vault_sku                        = "standard"
key_vault_enable_rbac_authorization  = true
key_vault_purge_protection_enabled   = false # so we can fully delete it
key_vault_soft_delete_retention_days = 7     # minimum


tls_cert_name   = "wildcard-onazureio"
tls_cert_issuer = "Unknown"
tls_cert_path   = "./certs/combined_star_onazure_io.pem"
