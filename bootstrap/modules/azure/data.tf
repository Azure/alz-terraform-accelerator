data "azurerm_subscription" "alz" {
  for_each        = local.subscription_ids
  subscription_id = each.key
}

data "azurerm_management_group" "alz" {
  display_name = var.root_management_group_display_name
}
