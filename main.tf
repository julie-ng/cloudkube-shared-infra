terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.50.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Reference to current ARM client
data "azurerm_client_config" "current" {}

# Resource Group
# --------------

resource "azurerm_resource_group" "shared_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.default_tags
}

resource "azurerm_management_lock" "locked_rg" {
  name       = "shared-rg-lock"
  scope      = azurerm_resource_group.shared_rg.id
  lock_level = "CanNotDelete"
  notes      = "These resources are shared by many projects and demos."
}

# DNS Zone
# --------

resource "azurerm_dns_zone" "onazureio" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  tags                = var.default_tags
}

resource "azurerm_dns_a_record" "dev_cluster" {
  name                = "dev"
  zone_name           = azurerm_dns_zone.onazureio.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  records             = [var.dev_cluster_public_ip]
}

resource "azurerm_dns_a_record" "dev_cluster_wildcard" {
  name                = "*.dev"
  zone_name           = azurerm_dns_zone.onazureio.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  records             = [var.dev_cluster_public_ip]
}

resource "azurerm_dns_cname_record" "appservice_node_demo" {
  name                = "nodejs-demo"
  zone_name           = azurerm_dns_zone.onazureio.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  record              = "azure-nodejs-demo.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "appservice_node_demo_dev" {
  name                = "nodejs-demo-dev"
  zone_name           = azurerm_dns_zone.onazureio.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  record              = "azure-nodejs-demo-dev.azurewebsites.net"
}

resource "azurerm_dns_mx_record" "hover_forward" {
  name                = "@"
  zone_name           = azurerm_dns_zone.onazureio.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 900

  record {
    preference = 10
    exchange   = "mx.hover.com.cust.hostedemail.com"
  }
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

resource "azurerm_key_vault_certificate" "tls_star" {
  name         = var.tls_cert_name
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64(var.tls_cert_path)
  }

  certificate_policy {
    # Note: Issuer name must be 'Self' or 'Unknown' per Docs
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate
    issuer_parameters {
      name = var.tls_cert_issuer
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
