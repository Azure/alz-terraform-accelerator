locals {
  private_dns_zones_enabled = { for key, value in var.hub_virtual_networks : key => try(value.private_dns_zones, null) != null }
}

locals {
  private_dns_zones = { for key, value in var.hub_virtual_networks : key => merge({
    location = value.hub_virtual_network.location
  }, value.private_dns_zones) if local.private_dns_zones_enabled[key] }

  private_dns_zones_auto_registration = { for key, value in var.hub_virtual_networks : key => merge({
    location         = value.hub_virtual_network.location
    vnet_resource_id = module.hub_and_spoke_vnet.virtual_networks[key].id
  }, value.private_dns_zones) if local.private_dns_zones_enabled[key] && try(value.private_dns_zones.auto_registration_zone_enabled, false) }

  private_dns_zones_virtual_network_links = {
    for key, value in module.hub_and_spoke_vnet.virtual_networks : key => {
      vnet_resource_id = value.id
    }
  }

  private_dns_resolver_ip_addresses = { for key, value in var.hub_virtual_networks : key =>
    (value.private_dns_zones.private_dns_resolver.ip_address == null ?
      cidrhost(value.private_dns_zones.subnet_address_prefix, 4) :
    value.private_dns_zones.private_dns_resolver.ip_address) if local.private_dns_zones_enabled[key]
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
