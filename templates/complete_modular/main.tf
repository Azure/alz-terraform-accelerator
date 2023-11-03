module "management_resources" {
  source  = "Azure/alz-management/azurerm"
  version = "~> 0.1.0"

  automation_account_name      = try(local.management.automation_account_name, "")
  location                     = try(local.management.location, "")
  log_analytics_workspace_name = try(local.management.log_analytics_workspace_name, "")
  resource_group_name          = try(local.management.resource_group_name, "")
}

module "management_groups" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.3.3"
  for_each                           = local.management_groups
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = try(each.value.base_archetype, "")
  default_location                   = try(each.value.default_location, var.default_location)
  default_log_analytics_workspace_id = try(each.value.default_log_analytics_workspace_id, "")
}

module "hub_networking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "1.1.0"
  count   = length(local.hub_virtual_networks) > 0 ? 1 : 0

  hub_virtual_networks = length(local.hub_virtual_networks) > 0 ? local.hub_virtual_networks : local.dummy_hub_virtual_network

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "vnet_gateway" {
  source  = "Azure/vnet-gateway/azurerm"
  version = "0.1.2"

  for_each = local.vritual_network_gateways

  location                            = each.value.location
  name                                = each.value.name
  sku                                 = each.value.sku
  subnet_address_prefix               = each.value.subnet_address_prefix
  type                                = each.value.type
  virtual_network_name                = each.value.virtual_network_name
  virtual_network_resource_group_name = each.value.virtual_network_resource_group_name
  default_tags                        = try(each.value.default_tags, null)
  edge_zone                           = try(each.value.edge_zone, null)
  express_route_circuits              = try(each.value.express_route_circuits, null)
  ip_configurations                   = try(each.value.ip_configurations, null)
  local_network_gateways              = try(each.value.local_network_gateways, null)
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
