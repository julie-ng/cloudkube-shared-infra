# =================
#  Storage Account
# =================

resource "azurerm_storage_account" "storageacct" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.shared_rg.name
  location                 = data.azurerm_resource_group.shared_rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = var.default_tags
}
