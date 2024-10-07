locals {
  resource_groups_hub_and_spoke_vnet = local.connectivity_hub_and_spoke_vnet_enabled ? merge({
    for key, value in local.hub_and_spoke_vnet_virtual_networks : key => {
      name     = value.hub_virtual_network.resource_group_name
      location = value.hub_virtual_network.location
    }},{
      for key, value in local.virtual_wan_virtual_hubs : key => {
        name     = value.private_dns_zones.resource_group_name
        location = value.hub_virtual_network.location
      } if can(value.private_dns_zones.resource_group_name)
    }
  ) : {}

  resource_groups_virtual_wan = local.connectivity_virtual_wan_enabled ? merge({ core = {
    name     = local.virtual_wan_settings.resource_group_name
    location = local.primary_location
    } }, {
      for key, value in local.virtual_wan_virtual_hubs : key => {
        name     = value.resource_group_name
        location = value.location
      } if value.resource_group_name != local.virtual_wan_settings.resource_group_name 
    } ,{
      for key, value in local.virtual_wan_virtual_hubs : key => {
        name     = value.private_dns_zones.resource_group_name
        location = value.location
      } if can(value.private_dns_zones.resource_group_name)
    }
  ) : {}

  resource_groups = merge(local.resource_groups_hub_and_spoke_vnet, local.resource_groups_virtual_wan)
}