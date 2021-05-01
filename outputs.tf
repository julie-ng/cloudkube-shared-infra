output "main" {
  value = {
    resource_group = {
      name     = azurerm_resource_group.shared_rg.name
      location = azurerm_resource_group.shared_rg.location
    }
    storage_account = {
      name                  = azurerm_storage_account.storageacct.name
      primary_blob_endpoint = azurerm_storage_account.storageacct.primary_blob_endpoint
    }
    container_registry = {
      # id           = azurerm_container_registry.acr.id
      sku          = azurerm_container_registry.acr.sku
      login_server = azurerm_container_registry.acr.login_server
    }
  }
}

# ===========
#  Key Vault
# ===========

output "key_vaults" {
  value = [
    for v in azurerm_key_vault.vaults : {
      name         = v.name
      sku          = v.sku_name
      rbac_enabled = v.enable_rbac_authorization
      vault_uri    = v.vault_uri
    }
  ]
}

output "tls_certificates" {
  value = {
    root      = [for c in azurerm_key_vault_certificate.tls_root_certs : {
      id      = c.id
      name    = c.name
      subject = c.certificate_policy[0].x509_certificate_properties[0].subject
    }]
    wildcards = [for c in azurerm_key_vault_certificate.tls_wildcard_certs : {
      id      = c.id
      name    = c.name
      subject = c.certificate_policy[0].x509_certificate_properties[0].subject
    }]
  }
}

# =====
#  DNS
# =====

output "DNS" {
  value = {
    zone = {
      name         = azurerm_dns_zone.shared_dns.name
      name_servers = [for s in azurerm_dns_zone.shared_dns.name_servers : s]
    }

    a_records = [
      for r in azurerm_dns_a_record.records : {
        fqdn    = r.fqdn
        records = r.records
      }
    ]

    cname_records = [
      for r in azurerm_dns_cname_record.records : {
        fqdn   = r.fqdn
        record = r.record
      }
    ]

    mx_record = {
      name   = azurerm_dns_mx_record.email.name
      record = azurerm_dns_mx_record.email.record
    }
  }
}
