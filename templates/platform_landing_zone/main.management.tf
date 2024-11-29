module "management_resources" {
  source = "./modules/management_resources"

  enable_telemetry             = var.enable_telemetry
  management_resource_settings = local.management_resource_settings
  tags                         = var.tags

  providers = {
    azurerm = azurerm.management
  }
}

module "management_groups" {
  source = "./modules/management_groups"

  enable_telemetry          = var.enable_telemetry
  management_group_settings = local.management_group_settings
  dependencies              = local.management_group_dependencies
}
