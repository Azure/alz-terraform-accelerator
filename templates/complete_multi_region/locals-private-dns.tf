locals {
  private_dns_zones_locations_hub_and_spoke_vnet = local.connectivity_hub_and_spoke_vnet_enabled ? {
    for key, value in var.hub_and_spoke_vnet_virtual_networks : key => {
      location   = value.location
      is_primary = value.location == var.location
    }
  } : {}
  private_dns_zones_locations_virtual_wan = local.connectivity_virtual_wan_enabled ? {} : {}
  private_dns_zone_locations              = merge(local.private_dns_zones_locations_hub_and_spoke_vnet, local.private_dns_zones_locations_virtual_wan)
}

locals {
  private_dns_zones_virtual_networks_hub_and_spoke_vnet = local.connectivity_hub_and_spoke_vnet_enabled ? {
    for key, value in local.hub_and_spoke_vnet_virtual_networks : key => {
      vnet_resource_id = module.hub_and_spoke_vnet[0].virtual_networks[key].resource_id
    }
  } : {}
  private_dns_zones_virtual_networks_virtual_wan = local.connectivity_virtual_wan_enabled ? {} : {}
  private_dns_zones_virtual_networks             = merge(local.private_dns_zones_virtual_networks_hub_and_spoke_vnet, local.private_dns_zones_virtual_networks_virtual_wan)
}
