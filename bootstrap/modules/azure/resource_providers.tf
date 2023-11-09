locals {
  resource_providers_by_subscriptions = flatten([
    for key, value in data.azurerm_subscription.alz : [
      for resource_provider in var.resource_providers :
      {
        subscription_id   = value.subscription_id
        resource_provider = resource_provider
      }
    ]
  ])

  resource_providers_to_register = {
    for resource_provider in local.resource_providers_by_subscriptions : "${resource_provider.subscription_id}_${resource_provider.resource_provider}" => resource_provider
  }
}

resource "azapi_resource_action" "resource_provider_registration" {
  for_each    = local.resource_providers_to_register
  type        = "Microsoft.Resources/subscriptions@2021-04-01"
  resource_id = "/subscriptions/${each.value.subscription_id}"
  action      = "providers/${each.value.resource_provider}/register"
  method      = "POST"
}

