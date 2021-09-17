# =======
#  Setup
# =======

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      version = ">= 2.76.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
