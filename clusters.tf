# ========================
#  AKS Clusters Resources
# ========================

# Static IPs

data "azurerm_public_ip" "dev" {
  name                = "cloudkube-dev-public-ip"
  resource_group_name = "cloudkube-dev-${var.dev_suffix}-rg"
}

data "azurerm_public_ip" "staging" {
  name                = "cloudkube-staging-public-ip"
  resource_group_name = "cloudkube-staging-${var.staging_suffix}-rg"
}
