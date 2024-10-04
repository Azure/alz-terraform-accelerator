locals {
  resource_groups_hub_and_spoke_vnet = {
    for key, value in local.hub_and_spoke_vnet_virtual_networks : key => {
      name = value.resource_group_name
      location = value.location
    }
  }

  resource_groups_virtual_wan = merge({ core = {
    name = local.virtual_wan_resource_group_name
    location = var.location
    }},{
    for key, value in local.virtual_wan_virtual_hubs : key => {
      name = value.resource_group_name
      location = value.location
    } if value.resource_group_name != local.var.virtual_wan_resource_group_name
  })

  resource_groups_private_dns_zones = !local.connectivity_none_enabled && var.private_dns_zones_enabled ? {
    dns = {
      name = local.private_dns_zones_resource_group_name
      location = value.location
    }
  } : {}

  resource_groups = merge(local.resource_groups_hub_and_spoke_vnet, local.resource_groups_virtual_wan, local.resource_groups_private_dns_zones)
}