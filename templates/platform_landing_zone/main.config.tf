module "config" {
  source = "./modules/config-templating"

  enable_telemetry = var.enable_telemetry

  starter_locations               = var.starter_locations
  subscription_id_connectivity    = try(var.subscription_ids["connectivity"], var.subscription_id_connectivity)
  subscription_id_identity        = try(var.subscription_ids["identity"], var.subscription_id_identity)
  subscription_id_management      = try(var.subscription_ids["management"], var.subscription_id_management)
  subscription_id_security        = var.subscription_ids["security"]
  root_parent_management_group_id = var.root_parent_management_group_id

  custom_replacements = var.custom_replacements

  connectivity_resource_groups        = var.connectivity_resource_groups
  hub_and_spoke_vnet_settings         = var.hub_and_spoke_vnet_settings
  hub_and_spoke_vnet_virtual_networks = var.hub_and_spoke_vnet_virtual_networks
  virtual_wan_settings                = var.virtual_wan_settings
  virtual_wan_virtual_hubs            = var.virtual_wan_virtual_hubs
  management_resource_settings        = var.management_resource_settings
  management_group_settings           = var.management_group_settings
  tags                                = var.tags
}
