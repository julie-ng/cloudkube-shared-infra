# ========================
#  Shared Infra for DevOps
# ========================

resource "azurerm_key_vault" "devops" {
  name                       = "${var.base_name}-devops-kv"
  location                   = var.location
  sku_name                   = var.key_vault_sku
  resource_group_name        = var.shared_rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  tags                       = var.default_tags
  enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
}

resource "azurerm_role_assignment" "devops_kv_admin" {
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.devops.id
}
