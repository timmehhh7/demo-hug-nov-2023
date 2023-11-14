resource "vault_azure_secret_backend" "azure" {
  path                    = "azure-demo"
  description             = "Demo Azure Backend"
  use_microsoft_graph_api = true
  subscription_id         = var.azure_secret_SUBSCRIPTION_ID
  tenant_id               = var.azure_secret_TENANT_ID
  client_id               = var.azure_secret_CLIENT_ID
  client_secret           = var.azure_secret_CLIENT_SECRET
}

resource "vault_azure_secret_backend_role" "demo" {
  backend = vault_azure_secret_backend.azure.path
  role    = "demo-nov-2023"
  ttl     = 300
  max_ttl = 900

  azure_roles {
    role_name = "Contributor"
    scope     = "/subscriptions/${var.subscription_id}"
  }
}