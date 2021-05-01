# ============
#  Key Vaults
# ============

resource "azurerm_key_vault" "vaults" {
  for_each                   = var.key_vault_names
  name                       = "${var.base_name}-${each.key}-kv"
  location                   = var.location
  sku_name                   = var.key_vault_sku
  resource_group_name        = azurerm_resource_group.shared_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  tags                       = var.default_tags
  enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
}

resource "azurerm_role_assignment" "vaults_admin" {
  for_each             = var.key_vault_names
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.vaults[each.key].id
}

# ==============
#  Certificates
# ==============

resource "azurerm_key_vault_certificate" "tls_root_certs" {
  for_each     = var.tls_certificates
  name         = each.value["root"].name
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.base_name}-${each.key}-kv"

  certificate {
    contents = filebase64(each.value["root"].cert_path)
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

# Wildcard Certificates

resource "azurerm_key_vault_certificate" "tls_wildcard_certs" {
  for_each     = var.tls_certificates
  name         = each.value["wildcard"].name
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.base_name}-${each.key}-kv"

  certificate {
    contents = filebase64(each.value["wildcard"].cert_path)
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

data "azurerm_user_assigned_identity" "ingress_managed_ids" {
  for_each            = var.ingress_configs
  name                = each.value.ingress_user_mi_name
  resource_group_name = each.value.ingress_user_mi_rg
}

resource "azurerm_role_assignment" "ingress_mi_kv_secrets_users" {
  for_each             = var.ingress_configs
  scope                = azurerm_key_vault.vaults[each.key].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_user_assigned_identity.ingress_managed_ids[each.key].principal_id
}
