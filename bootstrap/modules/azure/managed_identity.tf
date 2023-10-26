locals {
  user_assigned_managed_identities = {
    local.plan_key  = var.user_assigned_managed_identity_plan_name
    local.apply_key = var.user_assigned_managed_identity_apply_name
  }
  federated_credentials = var.create_federated_credential ? var.federated_credential_subjects : {}
}

resource "azurerm_user_assigned_identity" "alz" {
  for_each            = local.user_assigned_managed_identities
  location            = var.azure_location
  name                = each.value
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "alz" {
  for_each            = local.federated_credentials
  name                = "${var.federated_credential_name}-${each.key}"
  resource_group_name = azurerm_resource_group.identity.name
  audience            = [local.audience]
  issuer              = var.federated_credential_issuer
  parent_id           = azurerm_user_assigned_identity.alz[each.key].id
  subject             = each.value
}

locals {
  subscription_ids = { for subscription_id in distinct(var.target_subscriptions) : subscription_id => subscription_id }
}

data "azurerm_subscription" "alz" {
  for_each        = local.subscription_ids
  subscription_id = each.key
}

data "azurerm_management_group" "alz" {
  display_name = var.root_management_group_display_name
}

locals {
  subscription_role_assignments = merge({
    for subscription_id, subscription in data.azurerm_subscription.alz : subscription_id => {
      "plan_${subscription_id}" = {
        scope                = subscription.id
        role_definition_name = "Reader"
        principal_id         = azurerm_user_assigned_identity.alz[local.plan_key].principal_id
      }
      "apply_${subscription_id}" = {
        scope                = subscription.id
        role_definition_name = "Owner"
        principal_id         = azurerm_user_assigned_identity.alz[local.apply_key].principal_id
      }
    }
  })
  role_assignments = merge(local.subscription_role_assignments, {
    plan_management_group = {
      scope                = data.azurerm_management_group.alz.id
      role_definition_name = "Management Group Reader"
      principal_id         = azurerm_user_assigned_identity.alz[local.plan_key].principal_id
    }
    apply_management_group = {
      scope                = data.azurerm_management_group.alz.id
      role_definition_name = "Management Group Contributor"
      principal_id         = azurerm_user_assigned_identity.alz[local.apply_key].principal_id
    }
  })
}

resource "azurerm_role_assignment" "alz" {
  for_each             = local.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}