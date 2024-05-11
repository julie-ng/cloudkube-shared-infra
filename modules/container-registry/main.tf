# ====================
#  Container Registry
# ====================

# There is only 1 registry

data "azurerm_resource_group" "shared_rg" {
  name = var.resource_group
}

resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.shared_rg.name
  location            = data.azurerm_resource_group.shared_rg.location
  sku                 = var.registry_sku
  admin_enabled       = var.admin_enabled
  tags                = local.tags
}


# ==================
#  Role Assignments
# ==================

# Managed Identity & Pull

data "azurerm_user_assigned_identity" "mi_pullers" {
  for_each            = var.managed_identity_pullers
  name                = each.value.identity_name
  resource_group_name = each.value.resource_group
}

resource "azurerm_role_assignment" "mi_pullers" {
  for_each             = var.managed_identity_pullers
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_user_assigned_identity.mi_pullers[each.key].principal_id
}

# GitHub Workflow & push

resource "azurerm_role_assignment" "github_pushers" {
  for_each                         = var.github_pushers
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.acr.id
  principal_id                     = each.value.object_id
  skip_service_principal_aad_check = true
}
