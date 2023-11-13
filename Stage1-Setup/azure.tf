data "azurerm_billing_enrollment_account_scope" "main" {
  billing_account_name    = var.azure_billing_account_name
  enrollment_account_name = var.azure_enrollment_account_name
}

resource "azurerm_management_group" "demo-nov-2023" {
  display_name = "demo-nov-2023"
}

resource "azurerm_subscription" "main" {
  subscription_name = "main"
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.main.id
}

resource "azurerm_management_group_subscription_association" "main" {
  management_group_id = azurerm_management_group.demo-nov-2023.id
  subscription_id     = "/subscriptions/${azurerm_subscription.main.subscription_id}"
}
