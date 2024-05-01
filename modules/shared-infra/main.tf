# Me
data "azurerm_client_config" "current" {}

locals {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

# ================
#  Resource Group
# ================

resource "azurerm_resource_group" "shared_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.default_tags
}

# Disable Management Lock in Dev - so we can remove (work-in-progress) role assignments
# resource "azurerm_management_lock" "locked_rg" {
#   name       = "shared-rg-lock"
#   scope      = azurerm_resource_group.shared_rg.id
#   lock_level = "CanNotDelete"
#   notes      = "These resources are shared by many projects and demos."
# }
