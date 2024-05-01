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
