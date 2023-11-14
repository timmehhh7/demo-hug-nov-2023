provider "vault" {}

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.21.0"
    }
  }
  required_version = ">= 1.1"
}
