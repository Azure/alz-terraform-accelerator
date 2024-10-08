locals {
  config_template_file_variables = {
    starter_location_01                                           = var.starter_locations[0]
    starter_location_02                                           = try(var.starter_locations[1], null)
    starter_location_03                                           = try(var.starter_locations[2], null)
    starter_location_04                                           = try(var.starter_locations[3], null)
    starter_location_05                                           = try(var.starter_locations[4], null)
    starter_location_06                                           = try(var.starter_locations[5], null)
    starter_location_07                                           = try(var.starter_locations[6], null)
    starter_location_08                                           = try(var.starter_locations[7], null)
    starter_location_09                                           = try(var.starter_locations[8], null)
    starter_location_10                                           = try(var.starter_locations[9], null)
    starter_location_01_availability_zones                        = jsonencode(local.regions[var.starter_locations[0]].zones)
    starter_location_02_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[1]].zones, null))
    starter_location_03_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[2]].zones, null))
    starter_location_04_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[3]].zones, null))
    starter_location_05_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[4]].zones, null))
    starter_location_06_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[5]].zones, null))
    starter_location_07_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[6]].zones, null))
    starter_location_08_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[7]].zones, null))
    starter_location_09_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[8]].zones, null))
    starter_location_10_availability_zones                        = jsonencode(try(local.regions[var.starter_locations[9]].zones, null))
    starter_location_01_virtual_network_gateway_sku_express_route = local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[0]].express_route
    starter_location_02_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[1]].express_route, null)
    starter_location_03_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[2]].express_route, null)
    starter_location_04_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[3]].express_route, null)
    starter_location_05_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[4]].express_route, null)
    starter_location_06_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[5]].express_route, null)
    starter_location_07_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[6]].express_route, null)
    starter_location_08_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[7]].express_route, null)
    starter_location_09_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[8]].express_route, null)
    starter_location_10_virtual_network_gateway_sku_express_route = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[9]].express_route, null)
    starter_location_01_virtual_network_gateway_sku_vpn           = local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[0]].vpn
    starter_location_02_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[1]].vpn, null)
    starter_location_03_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[2]].vpn, null)
    starter_location_04_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[3]].vpn, null)
    starter_location_05_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[4]].vpn, null)
    starter_location_06_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[5]].vpn, null)
    starter_location_07_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[6]].vpn, null)
    starter_location_08_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[7]].vpn, null)
    starter_location_09_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[8]].vpn, null)
    starter_location_10_virtual_network_gateway_sku_vpn           = try(local.hub_and_spoke_vnet_gateway_default_skus[var.starter_locations[9]].vpn, null)
    root_parent_management_group_id                               = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity                                  = var.subscription_id_connectivity
    subscription_id_identity                                      = var.subscription_id_identity
    subscription_id_management                                    = var.subscription_id_management
  }
}
