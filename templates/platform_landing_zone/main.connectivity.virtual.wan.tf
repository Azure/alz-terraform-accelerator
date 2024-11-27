module "virtual_wan" {
  source = "./modules/virtual-wan"

  count = local.connectivity_virtual_wan_enabled ? 1 : 0

  virtual_wan_settings = local.virtual_wan_settings
  virtual_hubs         = local.virtual_wan_virtual_hubs
  enable_telemetry     = var.enable_telemetry
  tags                 = var.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}
