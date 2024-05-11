# Basics
variable "base_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "default_tags" {
  type = map(string)
  default = {
    demo = "true"
    iac  = "terraform"
  }
}

# DNS
variable "dns_zone_name" {}
variable "dns_a_records" {}
variable "dns_cname_records" {}

# Storage Account
variable "storage_account_name" {}
variable "storage_account_tier" {}
variable "storage_account_replication_type" {}
