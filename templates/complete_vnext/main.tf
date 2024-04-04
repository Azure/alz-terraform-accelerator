module "management_groups_layer_1" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_1
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = each.value.parent_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_2" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_2
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_1[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_3" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_3
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_2[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_4" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_4
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_3[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_5" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_5
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_4[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_6" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_6
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_5[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_groups_layer_7" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.6.0"
  for_each                           = local.management_groups_layer_7
  id                                 = each.value.id
  display_name                       = each.value.display_name
  parent_resource_id                 = module.management_groups_layer_6[each.value.parent].management_group_resource_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = local.log_analytics_workspace_id
  subscription_ids                   = each.value.subscriptions
}

module "management_resources" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.1.0"

  automation_account_name      = try(local.management.automation_account_name, "")
  location                     = try(local.management.location, "")
  log_analytics_workspace_name = try(local.management.log_analytics_workspace_name, "")
  resource_group_name          = try(local.management.resource_group_name, "")
  enable_telemetry             = false

  providers = {
    azurerm = azurerm.management
  }

  depends_on = [
    module.management_groups_layer_7
  ]
}

module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "~> 1.1.1"

  count = length(local.hub_virtual_networks) > 0 ? 1 : 0

  hub_virtual_networks = local.module_hubnetworking.hub_virtual_networks

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_resources
  ]
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "~> 0.2.0"

  for_each = local.module_virtual_network_gateway

  location                            = each.value.location
  name                                = each.value.name
  sku                                 = each.value.sku
  type                                = each.value.type
  virtual_network_name                = each.value.virtual_network_name
  virtual_network_resource_group_name = each.value.virtual_network_resource_group_name
  default_tags                        = try(each.value.default_tags, null)
  edge_zone                           = try(each.value.edge_zone, null)
  enable_telemetry                    = false
  express_route_circuits              = try(each.value.express_route_circuits, null)
  ip_configurations                   = try(each.value.ip_configurations, null)
  local_network_gateways              = try(each.value.local_network_gateways, null)
  subnet_address_prefix               = try(each.value.subnet_address_prefix, null)
  subnet_id                           = try(each.value.subnet_id, null)
  tags                                = try(each.value.tags, null)
  vpn_active_active_enabled           = try(each.value.vpn_active_active_enabled, null)
  vpn_bgp_enabled                     = try(each.value.vpn_bgp_enabled, null)
  vpn_bgp_settings                    = try(each.value.vpn_bgp_settings, null)
  vpn_generation                      = try(each.value.vpn_generation, null)
  vpn_point_to_site                   = try(each.value.vpn_point_to_site, null)
  vpn_type                            = try(each.value.vpn_type, null)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.hubnetworking
  ]
}
