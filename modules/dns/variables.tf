variable "resource_group_name" {}
variable "tags" {
  type    = map(string)
  default = {}
}

# DNS
variable "dns_zone_name" {}
variable "a_records" {}
variable "cname_records" {}
