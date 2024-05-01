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

# resource "azurerm_role_assignment" "vaults_admin" {
#   for_each             = var.key_vault_names
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
#   scope                = azurerm_key_vault.vaults[each.key].id
# }

# ==============
#  Certificates
# ==============

locals {
  dev_certificates = {
    for cert in var.dev_certificates :
    "dev-${cert.name}" => merge(cert, { key_vault = "cloudkube-dev-kv" })
  }

  staging_certificates = {
    for cert in var.staging_certificates :
    "staging-${cert.name}" => merge(cert, { key_vault = "cloudkube-staging-kv" })
  }

  prod_certificates = {
    for cert in var.prod_certificates :
    "prod-${cert.name}" => merge(cert, { key_vault = "cloudkube-prod-kv" })
  }

  all_certificates = merge(local.dev_certificates, local.staging_certificates, local.prod_certificates)
}

resource "azurerm_key_vault_certificate" "certs" {
  for_each     = local.all_certificates
  name         = each.value.name
  key_vault_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${each.value.key_vault}"

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
