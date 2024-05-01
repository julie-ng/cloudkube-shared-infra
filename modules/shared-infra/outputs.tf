# Resource Group
output "resource_group" {
  value = {
    name     = azurerm_resource_group.shared_rg.name
    location = azurerm_resource_group.shared_rg.location
  }
}

# Storage Account
output "storage_account" {
  value = {
    name                  = azurerm_storage_account.storageacct.name
    primary_blob_endpoint = azurerm_storage_account.storageacct.primary_blob_endpoint
  }
}

# Container Registry
output "container_registry" {
  value = {
    # id           = azurerm_container_registry.acr.id
    sku          = azurerm_container_registry.acr.sku
    login_server = azurerm_container_registry.acr.login_server
  }
}

# Key Vaults
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

# TLS Certificates
output "tls_certificates" {
  value = [for c in azurerm_key_vault_certificate.certs : c.id]
}

# DNS - records, zone
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
