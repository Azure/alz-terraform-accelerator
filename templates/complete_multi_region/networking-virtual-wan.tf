module "virtual_wan" {
  source = "./modules/virtual-wan"

  count = local.connectivity_virtual_wan_enabled ? 1 : 0

  name                = local.virtual_wan_name
  location            = var.location
  resource_group_name = local.virtual_wan_resource_group_name
  virtual_hubs        = local.virtual_wan_virtual_hubs

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups,
    module.resource_groups
  ]
}