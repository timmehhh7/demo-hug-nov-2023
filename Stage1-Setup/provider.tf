provider "google" {
}

provider "vault" {
  address = "https://vault.control.acceleratorlabs.ca"
}

provider "aws" {
}

provider "azuread" {}

provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.45.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.80.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.21.0"
    }
  }
  required_version = ">= 1.1"
}
