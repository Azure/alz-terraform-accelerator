locals {
  private_dns_virtual_networks_hub_and_spoke_vnet = (local.hub_networking_enabled ? 
      { for virtual_network_key, virtual_network in module.hub_and_spoke_vnet[0].virtual_networks : virtual_network_key => { vnet_resource_id = virtual_network.id } } :
      {}
  )
  private_dns_virtual_networks_virtual_wan = (local.virtual_wan_enabled ? 
      { "virtual_wan" = { vnet_resource_id = module.virtual_network_private_dns.resource_id} } :
      {}
  )
  private_dns_virtual_networks = merge(local.private_dns_virtual_networks_hub_and_spoke_vnet, local.private_dns_virtual_networks_virtual_wan)
  private_dns_secondary_locations = { for location in local.module_private_dns.secondary_locations : location => { is_primary = false } }
  private_dns_location_map = local.private_dns_enabled ? merge({
    try(local.module_private_dns.location, var.starter_locations[0]) = { is_primary = true }
  }, local.private_dns_secondary_locations) : {}
  private_dns_secondary_zones = {
    azure_data_explorer = {
      zone_name = "privatelink.{regionName}.kusto.windows.net"
    }
    azure_batch_account = {
      zone_name = "{regionName}.privatelink.batch.azure.com"
    }
    azure_batch_node_mgmt = {
      zone_name = "{regionName}.service.privatelink.batch.azure.com"
    }
    azure_aks_mgmt = {
      zone_name = "privatelink.{regionName}.azmk8s.io"
    }
    azure_acr_data = {
      zone_name = "{regionName}.data.privatelink.azurecr.io"
    }
    azure_backup = {
      zone_name = "privatelink.{regionCode}.backup.windowsazure.com"
    }
  }      
}