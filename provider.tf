# =======
#  Setup
# =======

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
