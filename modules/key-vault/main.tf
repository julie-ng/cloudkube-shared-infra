data "azurerm_client_config" "current" {}

# ===========
#  Key Vault
# ===========

data "azurerm_resource_group" "shared_rg" {
  name = var.resource_group
}

resource "azurerm_key_vault" "kv" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.shared_rg.name
  location            = data.azurerm_resource_group.shared_rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                   = var.sku
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  enable_rbac_authorization  = var.enable_rbac_authorization

  tags = var.tags
}


# ==============
#  Certificates
# ==============

locals {
  # Create map for easier terraform state debugging
  certificates = {
    for cert in var.certificates :
    "${cert.name}" => cert
  }
}

resource "azurerm_key_vault_certificate" "certs" {
  for_each     = local.certificates
  name         = each.value.name
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64(each.value.pem_file)
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


# ==================
#  Role Assignments
# ==================

# Managed identities

data "azurerm_user_assigned_identity" "managed_ids" {
  for_each            = var.reader_assignments
  name                = each.value.identity_name
  resource_group_name = each.value.resource_group
}

resource "azurerm_role_assignment" "readers_on_kv" {
  for_each             = var.reader_assignments
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User" # read-only role
  principal_id         = data.azurerm_user_assigned_identity.managed_ids[each.key].principal_id
}
