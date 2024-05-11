variable "name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "resource_group" {
  type        = string
  description = "Name of an existing Resource Group for this Key Vault"
}

variable "sku" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7 # minimum
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "enable_rbac_authorization" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "certificates" {
  type    = list(map(string))
  default = []
}

variable "reader_assignments" {
  type        = map(map(string))
  description = "Managed identities to grant read access to"
}
