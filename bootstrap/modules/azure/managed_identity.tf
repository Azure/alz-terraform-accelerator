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