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

# DNS Zone
# --------

resource "azurerm_dns_zone" "shared_dns" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  tags                = var.default_tags
}

resource "azurerm_dns_mx_record" "email" {
  name                = "@"
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  tags                = var.default_tags

  record {
    preference = 1
    exchange   = "ASPMX.L.GOOGLE.COM"
  }

  record {
    preference = 5
    exchange   = "ALT1.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 5
    exchange   = "ALT2.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 10
    exchange   = "ALT3.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 10
    exchange   = "ALT4.ASPMX.L.GOOGLE.COM."
  }
}

# A Records
resource "azurerm_dns_a_record" "records" {
  for_each            = var.dns_a_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  records             = each.value.records
}

# Cname Records
resource "azurerm_dns_cname_record" "records" {
  for_each            = var.dns_cname_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  record              = each.value.record
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

# Cert Role Assignments
# ---------------------
# Ingress Managed Identities to specific Certificates
# N.B. neither intended nor a good use case for innerSource

# data "azurerm_user_assigned_identity" "ingress_managed_ids" {
#   for_each            = var.ingress_configs
#   name                = each.value.ingress_user_mi_name
#   resource_group_name = each.value.ingress_user_mi_rg
# }

# resource "azurerm_role_assignment" "ingress_mi_kv_readers" {
#   for_each             = var.ingress_configs
#   scope                = "${azurerm_key_vault.kv.id}/certificates/${each.value.ingress_cert_name}"
#   role_definition_name = "Key Vault Reader"
#   principal_id         = data.azurerm_user_assigned_identity.ingress_managed_ids[each.key].principal_id
# }
