data "azurerm_client_config" "current" {}

# Resource Group
# --------------

resource "azurerm_resource_group" "shared_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.default_tags
}

# DNS Zone
# --------

resource "azurerm_dns_zone" "onazureio" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.shared_rg.name
}

# Container Registry
# ------------------

resource "azurerm_container_registry" "acr" {
  name                = var.azure_container_registry_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location
  sku                 = var.azure_container_registry_sku
  admin_enabled       = false
  tags                = var.default_tags
}

# Storage Account
# ---------------

resource "azurerm_storage_account" "storageacct" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.shared_rg.name
  location                 = azurerm_resource_group.shared_rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = var.default_tags
}

# Key Vault
# ---------

resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = var.location
  sku_name                   = var.key_vault_sku
  resource_group_name        = azurerm_resource_group.shared_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  tags                       = var.default_tags
  enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
}
