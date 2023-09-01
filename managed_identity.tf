resource "azurerm_user_assigned_identity" "alz" {
  location            = var.azure_location
  name                = local.resource_names.user_assigned_managed_identity
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "alz" {
  count = local.is_github || local.is_azure_devops && local.is_authentication_scheme_workload_identity_federation ? 1 : 0
  name                = local.resource_names.user_assigned_managed_identity_federated_credentials
  resource_group_name = azurerm_resource_group.identity.name
  audience            = [local.audience]
  issuer              = local.issuer
  parent_id           = azurerm_user_assigned_identity.alz.id
  subject             = local.subject
}