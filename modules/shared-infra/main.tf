# Me
data "azurerm_client_config" "current" {}

locals {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

# ================
#  Resource Group
# ================

resource "azurerm_resource_group" "shared_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.default_tags
}

# Disable Management Lock in Dev - so we can remove (work-in-progress) role assignments
# resource "azurerm_management_lock" "locked_rg" {
#   name       = "shared-rg-lock"
#   scope      = azurerm_resource_group.shared_rg.id
#   lock_level = "CanNotDelete"
#   notes      = "These resources are shared by many projects and demos."
# }


# ====================
#  Container Registry
# ====================

resource "azurerm_container_registry" "acr" {
  name                = var.azure_container_registry_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location
  sku                 = var.azure_container_registry_sku
  network_rule_set    = [] # Temporarily revert back to Basic SKU
  admin_enabled       = false
  tags                = var.default_tags
}

# =================
#  Storage Account
# =================

resource "azurerm_storage_account" "storageacct" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.shared_rg.name
  location                 = azurerm_resource_group.shared_rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = var.default_tags
}
