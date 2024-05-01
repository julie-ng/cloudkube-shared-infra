# =======
#  Setup
# =======

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      version = ">= 3.101.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}
