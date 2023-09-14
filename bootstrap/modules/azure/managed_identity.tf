resource "azurerm_user_assigned_identity" "alz" {
  location            = var.azure_location
  name                = var.user_assigned_managed_identity_name
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "alz" {
  count               = var.create_federated_credential ? 1 : 0
  name                = var.federated_credential_name
  resource_group_name = azurerm_resource_group.identity.name
  audience            = [local.audience]
  issuer              = var.federated_credential_issuer
  parent_id           = azurerm_user_assigned_identity.alz.id
  subject             = var.federated_credential_subject
}

data "azurerm_subscription" "alz" {
  for_each        = { for subscription in var.target_subscriptions : subscription => subscription }
  subscription_id = each.key
}

resource "azurerm_role_assignment" "alz_subscriptions" {
  for_each             = { for subscription in var.target_subscriptions : subscription => subscription }
  scope                = data.azurerm_subscription.alz[each.key].id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.alz.principal_id
}

data "azurerm_management_group" "alz" {
  display_name = "Tenant Root Group"
}

resource "azurerm_role_assignment" "alz_management_group" {
  scope                = data.azurerm_management_group.alz.id
  role_definition_name = "Management Group Contributor"
  principal_id         = azurerm_user_assigned_identity.alz.principal_id
}