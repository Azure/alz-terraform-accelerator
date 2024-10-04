module "virtual_wan" {
  source = "./modules/virtual-wan"

  count = var.connectity_type == "virtual_wan" ? 1 : 0

  virtual_hubs                          = var.virtual_hubs
  

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups
  ]
}