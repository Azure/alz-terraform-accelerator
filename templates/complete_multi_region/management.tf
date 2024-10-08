module "management_es" {
  source = "./modules/management-es"

  count = var.skip_deploy ? 0 : (var.management_use_avm ? 0 : 1)

  enable_telemetry = var.enable_telemetry
  settings         = local.management_settings_es

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}

module "management_avm" {
  source = "./modules/management-avm"

  count = var.skip_deploy ? 0 : (var.management_use_avm ? 1 : 0)

  enable_telemetry = var.enable_telemetry
  settings         = local.management_settings_avm

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
