# =========
#  Outputs
# =========

output "summary" {
  value = {
    azuread_app = {
      client_id = azuread_application.github.client_id
      object_id = azuread_application.github.object_id
    }
    service_principal = {
      object_id               = azuread_service_principal.github.object_id
      federated_credential_id = azuread_application_federated_identity_credential.github.credential_id
    }
  }
}
