# =====================
#  Self Reference (Me)
# =====================

data "azurerm_client_config" "current" {}

# ================
#  Resource Group
# ================

resource "azurerm_resource_group" "shared_rg" {
  name     = var.shared_rg_name
  location = var.location
  tags     = var.default_tags
}

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

  # Storage Account
  storage_account_name             = "cloudkubestorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"

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
}

# ======================
#  GitHub Workflows IDs
# ======================

module "github_identities" {
  source   = "./modules/github-federated-identity"
  for_each = var.github_identities

  base_name   = each.value.base_name # SP & credential base name
  github_org  = each.value.github_org
  github_repo = each.value.github_repo
  github_env  = each.value.github_env

  # MSFT Internal requirement
  service_management_reference = var.service_management_reference
}

# =========================
#  Consolidated Identities
# =========================
# because can't use variables in .tfvars

locals {
  dev_identtiies = {
    kubelet = {
      identity_name  = "cloudkube-dev-${var.dev_suffix}-kubelet-mi"
      resource_group = "cloudkube-dev-${var.dev_suffix}-rg"
    }
    ingress_mi = {
      identity_name  = "cloudkube-dev-${var.dev_suffix}-ingress-mi"
      resource_group = "cloudkube-dev-${var.dev_suffix}-rg"
    }
  }
}

# ===========
#  Key Vault
# ===========

# Make sure keys are always 'dev', 'staging', 'prod'

locals {
  kv_certificates = {
    dev     = var.dev_certificates
    staging = var.staging_certificates
    prod    = var.prod_certificates
  }

  kv_assignments = {
    dev     = local.dev_identtiies
    staging = {}
    prod    = {}
  }
}

module "key_vaults" {
  source             = "./modules/key-vault"
  for_each           = var.key_vault_names
  name               = each.value
  resource_group     = var.shared_rg_name
  tags               = var.default_tags
  certificates       = local.kv_certificates[each.key]
  reader_assignments = local.kv_assignments[each.key]
}

# ====================
#  Container Registry
# ====================

locals {
  dev_pullers = {
    for key, identity in local.dev_identtiies :
    "dev-${key}" => identity
  }

  # add more later when we have more clusters
  registry_pullers = merge({}, local.dev_pullers)

  github_pushers = {
    for k, identity in module.github_identities :
    "${k}" => identity.service_principal
  }
}

module "container_registry" {
  source         = "./modules/container-registry"
  name           = "cloudkubecr"
  resource_group = var.shared_rg_name

  managed_identity_pullers = local.registry_pullers
  github_pushers           = local.github_pushers
}
