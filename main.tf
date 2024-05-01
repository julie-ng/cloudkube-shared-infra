# =====================
#  Self Reference (Me)
# =====================

data "azurerm_client_config" "current" {}

# ========================
#  AKS Clusters Resources
# ========================

# Static IPs

data "azurerm_public_ip" "dev" {
  name                = "cloudkube-dev-aks-ingress-ip"
  resource_group_name = "cloudkube-dev-networking-rg"
}

# data "azurerm_public_ip" "staging" {
#   name                = "cloudkube-staging-ingress-ip"
#   resource_group_name = "cloudkube-staging-${var.staging_suffix}-rg"
# }

# ==============
#  Shared Infra
# ==============

module "cloudkube" {
  source = "./modules/shared-infra"

  # Basics
  base_name           = var.base_name
  location            = var.location
  resource_group_name = var.shared_rg_name
  default_tags        = var.default_tags

  # Azure Container Registry
  azure_container_registry_name = "cloudkubecr"
  azure_container_registry_sku  = "Basic"

  # Storage Account
  storage_account_name             = "cloudkubestorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"

  # Key Vault Defaults
  key_vault_names                      = var.key_vault_names
  key_vault_sku                        = var.key_vault_sku
  key_vault_enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
  key_vault_purge_protection_enabled   = var.key_vault_purge_protection_enabled
  key_vault_soft_delete_retention_days = var.key_vault_soft_delete_retention_days

  # tls_certificates = var.tls_certificates
  dev_certificates     = var.dev_certificates
  staging_certificates = var.staging_certificates
  prod_certificates    = var.prod_certificates

  # DNS Records
  dns_zone_name     = "cloudkube.io"
  dns_cname_records = var.dns_cname_records
  dns_a_records = {
    dev_cluster = {
      name    = "dev"
      records = [data.azurerm_public_ip.dev.ip_address]
    }
    dev_cluster_wildcard = {
      name    = "*.dev"
      records = [data.azurerm_public_ip.dev.ip_address]
    }
    # staging_cluster = {
    #   name    = "staging"
    #   records = [data.azurerm_public_ip.staging.ip_address]
    # }
    # staging_cluster_wildcard = {
    #   name    = "*.staging"
    #   records = [data.azurerm_public_ip.staging.ip_address]
    # }
  }

  # TLS certificate config
  ingress_configs = {
    dev = {
      ingress_user_mi_name = "cloudkube-dev-${var.dev_suffix}-kubelet-mi"
      ingress_user_mi_rg   = "cloudkube-dev-${var.dev_suffix}-rg"
    }
    # staging = {
    #   ingress_user_mi_name = "cloudkube-staging-${var.staging_suffix}-kubelet-mi"
    #   ingress_user_mi_rg   = "cloudkube-staging-${var.staging_suffix}-rg"
    # }
  }
}
