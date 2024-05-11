output "dns_zone" {
  value = {
    name         = azurerm_dns_zone.shared_dns.name
    name_servers = [for s in azurerm_dns_zone.shared_dns.name_servers : s]
  }
}

output "a_records" {
  value = [
    for r in azurerm_dns_a_record.records : {
      fqdn    = r.fqdn
      records = r.records
    }
  ]
}

output "cname_records" {
  value = [
    for r in azurerm_dns_cname_record.records : {
      fqdn   = r.fqdn
      record = r.record
    }
  ]
}

output "mx_record" {
  value = {
    name   = azurerm_dns_mx_record.email.name
    record = azurerm_dns_mx_record.email.record
  }
}
