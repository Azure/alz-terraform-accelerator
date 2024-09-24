locals {
  private_dns_virtual_networks_hub_and_spoke_vnet = (local.hub_networking_enabled ?
    { for key, value in try(module.hub_and_spoke_vnet[0].virtual_networks, {}) : key => { vnet_resource_id = value.id } } :
    {}
  )
  private_dns_virtual_networks_virtual_wan = (local.virtual_wan_enabled ?
    { for key, value in try(local.module_virtual_wan.virtual_hubs, {}) : key => { vnet_resource_id = module.virtual_network_private_dns[key].resource_id } } :
    {}
  )
  private_dns_virtual_networks = merge(local.private_dns_virtual_networks_hub_and_spoke_vnet, local.private_dns_virtual_networks_virtual_wan)
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