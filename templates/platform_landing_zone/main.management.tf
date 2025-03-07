module "management_resources" {
  source = "./modules/management_resources"

  enable_telemetry             = var.enable_telemetry
  management_resource_settings = module.config.management_resource_settings
  tags                         = module.config.tags

  providers = {
    azurerm = azurerm.management
  }
}

module "management_groups" {
  source = "./modules/management_groups"

  enable_telemetry          = var.enable_telemetry
  management_group_settings = module.config.management_group_settings
  dependencies              = local.management_group_dependencies
}
