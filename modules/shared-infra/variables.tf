# Basics
variable "base_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "default_tags" {
  type = map(string)
  default = {
    demo   = "true"
    public = "true"
  }
}

# DNS
variable "dns_zone_name" {}

# ACR
variable "azure_container_registry_name" {}
variable "azure_container_registry_sku" {}

# Storage Account
variable "storage_account_name" {}
variable "storage_account_tier" {}
variable "storage_account_replication_type" {}

# Key Vault
variable "key_vault_sku" {}
variable "key_vault_soft_delete_retention_days" {}
variable "key_vault_purge_protection_enabled" {}
variable "key_vault_enable_rbac_authorization" {}

# Certificates
variable "key_vault_names" {}
variable "tls_certificates" {
  type    = map(map(map(string)))
  default = {}
}

variable "dns_a_records" {}

# See *.auto.tfvars
variable "dns_cname_records" {}
variable "ingress_configs" {}
