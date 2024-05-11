variable "name" {}
variable "resource_group" {}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "registry_sku" {
  type    = string
  default = "Basic"
}

variable "managed_identity_pullers" {
  type        = map(map(string))
  description = "Map names and respective resource groups to grant 'AcrPull' access."
}

variable "github_pushers" {
  type = map(map(string))
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "default_tags" {
  type = map(string)
  default = {
    demo = "true"
    env  = "prod"
    iac  = "terraform"
  }
}

locals {
  tags = merge(var.default_tags, var.tags)
}
