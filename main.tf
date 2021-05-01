# =======
#  Setup
# =======

terraform {
  backend "azurerm" {
  }
}

variable "dns_a_records" {}
variable "dns_cname_records" {}
variable "ingress_configs" {}

# ==============
#  Shared Infra
# ==============

module "cloudkube" {
  source = "./modules/shared-infra"

  # Basics
  base_name           = "cloudkube"
  location            = "northeurope"
  resource_group_name = "cloudkube-shared-rg"
  default_tags = {
    public = "true"
    demo   = "true"
    env    = "prod"
    iac    = "terraform"
  }

  # DNS
  dns_zone_name     = "cloudkube.io"
  dns_a_records     = var.dns_a_records
  dns_cname_records = var.dns_cname_records

  # Azure Container Registry
  azure_container_registry_name = "cloudkubecr"
  azure_container_registry_sku  = "Basic"

  # Storage Account
  storage_account_name             = "cloudkubestorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"

  # Key Vault Defaults
  key_vault_sku                        = "standard"
  key_vault_enable_rbac_authorization  = true
  key_vault_purge_protection_enabled   = false # so we can fully delete it
  key_vault_soft_delete_retention_days = 7     # minimum

  key_vault_names = {
    dev     = "cloudkube-dev-kv"
    staging = "cloudkube-staging-kv"
    prod    = "cloudkube-prod-kv"
  }

  # TLS certificate config
  ingress_configs = var.ingress_configs

  tls_certificates = {
    dev = {
      root = {
        name      = "dev-cloudkube"
        cert_path = "./certs/combined_dev_cloudkube_io.pem"
      }
      wildcard = {
        name      = "wildcard-dev-cloudkube"
        cert_path = "./certs/combined_star_dev_cloudkube_io.pem"
      }
    }

    staging = {
      root = {
        name      = "staging-cloudkube"
        cert_path = "./certs/combined_staging_cloudkube_io.pem"
      }

      wildcard = {
        name      = "wildcard-staging-cloudkube"
        cert_path = "./certs/combined_star_staging_cloudkube_io.pem"
      }
    }

    prod = {
      root = {
        name      = "cloudkube"
        cert_path = "./certs/combined_root_cloudkube_io.pem"
      }
      wildcard = {
        name      = "wildcard-cloudkube"
        cert_path = "./certs/combined_star_cloudkube_io.pem"
      }
    }
  }
}

# =========
#  Outputs
# =========

output "summary" {
  value = {
    main             = module.cloudkube.main
    DNS              = module.cloudkube.DNS
    key_vaults       = module.cloudkube.key_vaults
    tls_certificates = module.cloudkube.tls_certificates
  }
}
