data "azuread_client_config" "current" {}

# ========================
#  Shared Infra for DevOps
# ========================

# Key Vault
# ---------

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

# Key Vault Reader
# ----------------

# Create KV Reader for Azure DevOps Key Vault Integration

resource "azuread_application" "ci_kv_reader" {
  display_name = "${var.base_name}-ci-kv-reader-sp"
  owners       = [data.azuread_client_config.current.object_id]
}
resource "azuread_service_principal" "ci_kv_reader" {
  application_id               = azuread_application.ci_kv_reader.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Now store this KV readers client id & secret in Key Vault so we can access it

resource "azuread_service_principal_password" "ci_kv_reader" {
  service_principal_id = azuread_service_principal.ci_kv_reader.object_id
}

resource "azurerm_key_vault_secret" "ci_kv_reader_client_id" {
  name         = "${var.base_name}-ci-kv-reader-client-id"
  value        = azuread_service_principal.ci_kv_reader.application_id
  key_vault_id = azurerm_key_vault.devops.id
}

resource "azurerm_key_vault_secret" "ci_kv_reader_client_secret" {
  name         = "${var.base_name}-ci-kv-reader-client-secret"
  value        = azuread_service_principal_password.ci_kv_reader.value
  key_vault_id = azurerm_key_vault.devops.id
}


# ==================
#  Role Assignments
# ==================

# Give myself admin access

resource "azurerm_role_assignment" "devops_kv_admin" {
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.devops.id
}

# Give CI Service Principal Read-only Access

resource "azurerm_role_assignment" "devops_kv_reader" {
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.ci_kv_reader.object_id
  scope                = azurerm_key_vault.devops.id
}


# Azure DevOps also needs reader on whole subscription 🤷‍♀️

data "azurerm_subscription" "current" {}
resource "azurerm_role_assignment" "devops_sub_reader" {
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.ci_kv_reader.object_id
  scope                = data.azurerm_subscription.current.id
}
