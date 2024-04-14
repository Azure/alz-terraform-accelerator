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
}

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


module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "~> 1.1.1"

  count = length(local.hub_virtual_networks) > 0 ? 1 : 0

  hub_virtual_networks = local.module_hubnetworking.hub_virtual_networks

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups_layer_7
  ]
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "~> 0.3.0"

  for_each = local.module_virtual_network_gateway

  location                                  = each.value.location
  name                                      = each.value.name
  sku                                       = try(each.value.sku, null)
  type                                      = try(each.value.type, null)
  virtual_network_id                        = each.value.virtual_network_id
  default_tags                              = try(each.value.default_tags, null)
  subnet_creation_enabled                   = try(each.value.subnet_creation_enabled, null)
  edge_zone                                 = try(each.value.edge_zone, null)
  enable_telemetry                          = false
  express_route_circuits                    = try(each.value.express_route_circuits, null)
  ip_configurations                         = try(each.value.ip_configurations, null)
  local_network_gateways                    = try(each.value.local_network_gateways, null)
  subnet_address_prefix                     = try(each.value.subnet_address_prefix, null)
  tags                                      = try(each.value.tags, null)
  vpn_active_active_enabled                 = try(each.value.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.route_table_name, null)
  route_table_tags                          = try(each.value.route_table_tags, null)

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "vwan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "~> 0.4.0"

  count = length(local.module_vwan) > 0 ? 1 : 0

  allow_branch_to_branch_traffic        = try(local.module_vwan.allow_branch_to_branch_traffic, null)
  create_resource_group                 = try(local.module_vwan.create_resource_group, null)
  disable_vpn_encryption                = try(local.module_vwan.disable_vpn_encryption, null)
  enable_telemetry                      = try(local.module_vwan.enable_telemetry, null)
  er_circuit_connections                = try(local.module_vwan.er_circuit_connections, null)
  expressroute_gateways                 = try(local.module_vwan.expressroute_gateways, null)
  firewalls                             = try(local.module_vwan.firewalls, null)
  office365_local_breakout_category     = try(local.module_vwan.office365_local_breakout_category, null)
  location                              = try(local.module_vwan.location, null)
  p2s_gateway_vpn_server_configurations = try(local.module_vwan.p2s_gateway_vpn_server_configurations, null)
  p2s_gateways                          = try(local.module_vwan.p2s_gateways, null)
  resource_group_name                   = try(local.module_vwan.resource_group_name, null)
  virtual_hubs                          = try(local.module_vwan.virtual_hubs, null)
  virtual_network_connections           = try(local.module_vwan.virtual_network_connections, null)
  virtual_wan_name                      = try(local.module_vwan.virtual_wan_name, null)
  type                                  = try(local.module_vwan.type, null)
  routing_intents                       = try(local.module_vwan.routing_intents, null)
  resource_group_tags                   = try(local.module_vwan.resource_group_tags, null)
  telemetry_resource_group_name         = try(local.module_vwan.telemetry_resource_group_name, null)
  virtual_wan_tags                      = try(local.module_vwan.virtual_wan_tags, null)
  vpn_gateways                          = try(local.module_vwan.vpn_gateways, null)
  vpn_site_connections                  = try(local.module_vwan.vpn_site_connections, null)
  vpn_sites                             = try(local.module_vwan.vpn_sites, null)
  tags                                  = try(local.module_vwan.tags, null)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups_layer_7
  ]
}
