data "azuread_client_config" "current" {}

# ===========
#  Resources
# ===========

resource "azuread_application" "github" {
  display_name = "${var.base_name}-github-actions-${var.github_env}" # e.g. aks-cheatsheets-github-actions-dev
  owners       = [data.azuread_client_config.current.object_id]

  # Microsoft internal requirement
  notes                        = var.notes
  service_management_reference = var.service_management_reference
}

# resource "azuread_application_registration" "app" {
#   display_name     = "${var.base_name}-github-actions-${var.github_env}" # e.g. aks-cheatsheets-github-actions-dev
#   description      = var.description
#   sign_in_audience = "AzureADMyOrg"
#   owners           = [data.azuread_client_config.current.object_id]

#   # Microsoft internal requirement
#   notes                        = var.notes
#   service_management_reference = var.service_management_reference
# }

resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
  notes     = var.notes
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.github.id
  display_name   = "${var.base_name}-${var.github_env}-github-deploy"
  description    = "GitHub Actions Deployments for ${var.github_org}/${var.github_repo} repo, '${var.github_env}' environment"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:environment:${var.github_env}"
}

