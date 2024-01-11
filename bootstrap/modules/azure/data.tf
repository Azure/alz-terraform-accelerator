data "azurerm_subscription" "alz" {
  for_each        = local.subscription_ids
  subscription_id = each.key
}

data "azurerm_management_group" "alz" {
  display_name = var.root_management_group_display_name
}

data "http" "ip" {
  count = local.use_private_networking && var.allow_storage_access_from_my_ip ? 1 : 0
  url   = "https://api.ipify.org/"
}
