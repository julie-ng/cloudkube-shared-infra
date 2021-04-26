# Cert Role Assignments
# ---------------------
# Ingress Managed Identities to specific Certificates
# N.B. neither intended nor a good use case for innerSource

data "azurerm_user_assigned_identity" "ingress_managed_ids" {
  for_each            = var.ingress_configs
  name                = each.value.ingress_user_mi_name
  resource_group_name = each.value.ingress_user_mi_rg
}

resource "azurerm_role_assignment" "ingress_mi_kv_readers" {
  for_each             = var.ingress_configs
  scope                = "${azurerm_key_vault.kv.id}/certificates/${each.value.ingress_cert_name}"
  role_definition_name = "Key Vault Reader"
  principal_id         = data.azurerm_user_assigned_identity.ingress_managed_ids[each.key].principal_id
}
