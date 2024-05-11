output "container_registry" {
  value = {
    name         = azurerm_container_registry.acr.name
    login_server = azurerm_container_registry.acr.login_server
  }
}

output "managed_identity_pullers" {
  value = { for k, mi in azurerm_role_assignment.mi_pullers :
    "${k}" => {
      assignment_id = mi.id
      principal_id  = mi.principal_id
      role_name     = mi.role_definition_name
    }
  }
}

output "github_pushers" {
  value = { for k, sp in azurerm_role_assignment.github_pushers :
    "${k}" => {
      assignment_id = sp.id
      principal_id  = sp.principal_id
      role_name     = sp.role_definition_name
    }
  }
}
