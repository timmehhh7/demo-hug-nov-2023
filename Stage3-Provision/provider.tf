provider "google" {
  region      = "northamerica-northeast1"
  credentials = base64decode(data.vault_generic_secret.creds.data.private_key_data)
}

provider "vault" {}

provider "aws" {
  region     = "ca-central-1"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

provider "azurerm" {
  client_id       = data.vault_azure_access_credentials.creds.client_id
  client_secret   = data.vault_azure_access_credentials.creds.client_secret
  subscription_id = "7a517e97-91a1-4629-81c4-f65dfe169f57"
  tenant_id       = "4328f5c5-4e1f-4b4d-b5ee-604e7fe12ccf"
  features {}
}

terraform {
  required_providers {
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
