locals {
  private_dns_zones_enabled = { for key, value in var.virtual_hubs : key => try(value.private_dns_zones, null) != null }
}

locals {
  private_dns_zones = { for key, value in var.virtual_hubs : key => merge({
    location = value.hub.location
  }, value.private_dns_zones) if local.private_dns_zones_enabled[key] }

  private_dns_zones_auto_registration = { for key, value in var.virtual_hubs : key => merge({
    location         = value.hub.location
    vnet_resource_id = module.virtual_network_side_car[key].resource_id
  }, value.private_dns_zones) if local.private_dns_zones_enabled[key] && try(value.private_dns_zones.auto_registration_zone_enabled, false) }

  private_dns_zones_virtual_network_links = {
    for key, value in module.virtual_network_side_car : key => {
      vnet_resource_id = value.resource_id
    }
  }

  private_dns_zones_secondary_zones = {
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
