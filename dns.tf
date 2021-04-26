# DNS Zone
# --------

resource "azurerm_dns_zone" "shared_dns" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.shared_rg.name
  tags                = var.default_tags
}

# A Records
resource "azurerm_dns_a_record" "records" {
  for_each            = var.dns_a_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  records             = each.value.records
}

# Cname Records
resource "azurerm_dns_cname_record" "records" {
  for_each            = var.dns_cname_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  record              = each.value.record
}

resource "azurerm_dns_mx_record" "email" {
  name                = "@"
  zone_name           = azurerm_dns_zone.shared_dns.name
  resource_group_name = azurerm_resource_group.shared_rg.name
  ttl                 = 300
  tags                = var.default_tags

  record {
    preference = 1
    exchange   = "ASPMX.L.GOOGLE.COM"
  }

  record {
    preference = 5
    exchange   = "ALT1.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 5
    exchange   = "ALT2.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 10
    exchange   = "ALT3.ASPMX.L.GOOGLE.COM."
  }

  record {
    preference = 10
    exchange   = "ALT4.ASPMX.L.GOOGLE.COM."
  }
}
