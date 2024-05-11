variable "dev_suffix" {}
variable "staging_suffix" {}
variable "dns_cname_records" {}

variable "shared_rg_name" {}
variable "base_name" {}
variable "location" {}

variable "default_tags" {
  type = map(string)
  default = {
    demo = "true"
    env  = "prod"
    iac  = "terraform"
  }
}


# Key Vault
# ---------

variable "key_vault_names" {}


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

# Key Vault Readers
# -----------------

variable "dev_kv_readers" {
  type        = map(map(string))
  description = "Map of managed identities to give Read permissions to the *dev* Key Vault"
  default     = {}
}

variable "staging_kv_readers" {
  type        = map(map(string))
  description = "Map of managed identities to give Read permissions to the *staging* Key Vault"
  default     = {}
}

variable "prod_kv_readers" {
  type        = map(map(string))
  description = "Map of managed identities to give Read permissions to the *prod* Key Vault"
  default     = {}
}

# Federated Identities for Deploymnet

variable "github_identities" {
  type = map(map(string))
}

variable "service_management_reference" {
  type    = string
  default = "" # set in private.auto.tfvars
}
