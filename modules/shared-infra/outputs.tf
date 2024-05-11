# Storage Account
output "storage_account" {
  value = {
    name                  = azurerm_storage_account.storageacct.name
    primary_blob_endpoint = azurerm_storage_account.storageacct.primary_blob_endpoint
  }
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
