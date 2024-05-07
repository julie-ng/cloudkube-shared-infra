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

# ======================
#  GitHub Workflows IDs
# ======================

locals {
  github_identities_map = {
    for i, identity in var.github_identities :
    "${identity.base_name}-${identity.github_env}" => identity
  }
}

module "github_identities" {
  source   = "./modules/github-federated-identity"
  for_each = local.github_identities_map

  base_name   = each.value.base_name
  github_org  = each.value.github_org
  github_repo = each.value.github_repo
  github_env  = each.value.github_env

  # MSFT Internal requirement
  service_management_reference = var.service_management_reference
}


# Role Assignments on Container Registry
data "azurerm_container_registry" "cloudkube" {
  name                = "${var.base_name}cr"
  resource_group_name = var.shared_rg_name
}

resource "azurerm_role_assignment" "github_federated_ids_on_acr" {
  for_each                         = local.github_identities_map
  role_definition_name             = "AcrPush" # "8311e382-0749-4cb8-b61a-304f252e45ec"
  scope                            = data.azurerm_container_registry.cloudkube.id
  principal_id                     = module.github_identities["${each.value.base_name}-${each.value.github_env}"].summary.service_principal.object_id
  skip_service_principal_aad_check = true

  depends_on = [
    module.cloudkube,
    module.github_identities
  ]
}
