locals {
  private_dns_zones_locations_hub_and_spoke_vnet = var.connectity_type == "hub_and_spoke_vnet" ? {
    for key, value in var.hub_and_spoke_vnet_virtual_networks : key => {
      location   = value.location
      is_primary = value.location == var.location
    }
  } : {}
  private_dns_zones_locations_virtual_wan = var.connectity_type == "virtual_wan" ? {} : {}
  private_dns_zone_locations = merge(local.private_dns_zones_locations_hub_and_spoke_vnet, local.private_dns_zones_locations_virtual_wan)
}

locals {
  private_dns_zones_virtual_networks_hub_and_spoke_vnet = var.connectity_type == "hub_and_spoke_vnet" ? { 
    for key, value in try(local.module_hub_and_spoke_vnet.hub_virtual_networks, {}) : key => { 
      vnet_resource_id = module.hub_and_spoke_vnet[0].virtual_networks[key].resource_id 
    } 
  } : {}
  private_dns_zones_virtual_networks_virtual_wan = var.connectity_type == "virtual_wan" ? {} : {}
  private_dns_zones_virtual_networks = merge(local.private_dns_zones_virtual_networks_hub_and_spoke_vnet, local.private_dns_zones_virtual_networks_virtual_wan)
}
