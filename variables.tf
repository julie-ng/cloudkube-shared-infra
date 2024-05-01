variable "dev_suffix" {}
variable "staging_suffix" {}
variable "dns_cname_records" {}
variable "default_tags" {}
variable "shared_rg_name" {}
variable "base_name" {}
variable "location" {}

# Key Vault
# ---------

variable "key_vault_names" {}
variable "key_vault_sku" {}
variable "key_vault_enable_rbac_authorization" {}
variable "key_vault_purge_protection_enabled" {}
variable "key_vault_soft_delete_retention_days" {}

# TLS Certs
# ---------

variable "dev_certificates" {
  type        = list(map(string))
  description = "List of certificates to save in `cloudkube-dev-kv`"
}

variable "staging_certificates" {
  type        = list(map(string))
  description = "List of certificates to save in `cloudkube-staging-kv`"
}

variable "prod_certificates" {
  type        = list(map(string))
  description = "List of certificates to save in `cloudkube-prod-kv`"
}
