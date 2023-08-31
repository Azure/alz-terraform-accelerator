resource "azurerm_resource_group" "state" {
  name     = "${var.prefix}-state"
  location = var.location
}

resource "azurerm_resource_group" "identity" {
  name     = "${var.prefix}-identity"
  location = var.location
}

resource "azurerm_resource_group" "agents" {
  name     = "${var.prefix}-agents"
  location = var.location
}

resource "azurerm_resource_group" "example" {
  for_each = { for env in var.environments : env => env }
  name     = "${var.prefix}-${each.value}"
  location = var.location
}

resource "azurerm_role_assignment" "example" {
  for_each             = { for env in var.environments : env => env }
  scope                = azurerm_resource_group.example[each.value].id
  role_definition_name = "Contributor"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.example[each.value].principal_id : azuread_service_principal.github_oidc[each.value].id
}