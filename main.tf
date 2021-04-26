# Me
data "azurerm_client_config" "current" {}

# Resource Group
# --------------

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

# Container Registry
# ------------------

resource "azurerm_container_registry" "acr" {
  name                = var.azure_container_registry_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location
  sku                 = var.azure_container_registry_sku
  network_rule_set    = [] # Temporarily revert back to Basic SKU
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

resource "azurerm_role_assignment" "admin" {
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.kv.id
}

# Certificates
# ------------
# - are not checked into git
# - Issuer name must be 'Self' or 'Unknown' per Docs:
#   https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate

resource "azurerm_key_vault_certificate" "cert" {
  for_each     = var.tls_certificates
  name         = each.value.name
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64(each.value.cert_path)
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }
  }
}
