module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "0.11.8"

  count = local.connectivity_virtual_wan_enabled ? 1 : 0

  virtual_wan_settings = local.virtual_wan_settings
  virtual_hubs         = local.virtual_wan_virtual_hubs
  enable_telemetry     = var.enable_telemetry
  tags                 = try(local.virtual_wan_settings.tags, module.config.tags)

  providers = {
    azurerm = azurerm.connectivity
  }
}
