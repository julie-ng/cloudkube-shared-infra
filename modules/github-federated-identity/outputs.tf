# =========
#  Outputs
# =========

output "azuread_app" {
  value = {
    display_name = azuread_application.github.display_name
    client_id    = azuread_application.github.client_id
    object_id    = azuread_application.github.object_id
  }
}

output "service_principal" {
  value = {
    display_name = azuread_service_principal.github.display_name
    object_id    = azuread_service_principal.github.object_id
  }
}

output "federated_credential_id" {
  value = azuread_application_federated_identity_credential.github.credential_id
}
