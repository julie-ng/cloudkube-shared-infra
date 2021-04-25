output "summary" {
  value = {
    resource_group = {
      name     = azurerm_resource_group.shared_rg.name
      location = azurerm_resource_group.shared_rg.location
    }
    key_vault = {
      name = azurerm_key_vault.kv.name
      id   = azurerm_key_vault.kv.id
      uri  = azurerm_key_vault.kv.vault_uri
      certs = [for c in azurerm_key_vault_certificate.cert : {
        id      = c.id
        name    = c.name
        subject = c.certificate_policy[0].x509_certificate_properties[0].subject
      }]
    }
    storage_account = {
      name                  = azurerm_storage_account.storageacct.name
      primary_blob_endpoint = azurerm_storage_account.storageacct.primary_blob_endpoint
    }
    dns_zone = {
      name         = azurerm_dns_zone.shared_dns.name
      name_servers = [for s in azurerm_dns_zone.shared_dns.name_servers : s]
      mx_records   = azurerm_dns_mx_record.email
    }
  }
}

# output "certificate_role_assginments" {
#   value = [
#     for k, v in zipmap( # needed to combine resource and data sources
#       keys(azurerm_role_assignment.ingress_mi_kv_readers),
#     values(azurerm_role_assignment.ingress_mi_kv_readers)) :
#     {
#       tostring(k) = {
#         id                   = v.id
#         scope                = v.scope
#         role_definition_name = v.role_definition_name
#         principal_id         = v.principal_id
#         principal_type       = v.principal_type
#         principal_name       = data.azurerm_user_assigned_identity.ingress_managed_ids[k].name
#         principal_rg         = data.azurerm_user_assigned_identity.ingress_managed_ids[k].resource_group_name
#       }
#     }
#   ]
# }

output "dns_a_records" {
  value = [
    for r in azurerm_dns_a_record.records : {
      fqdn    = r.fqdn
      records = r.records
    }
  ]
}

# output "dns_cname_records" {
#   value = [
#     for r in azurerm_dns_cname_record.records : {
#       fqdn   = r.fqdn
#       record = r.record
#     }
#   ]
# }