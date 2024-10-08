locals {
  hub_virtual_networks = {
    for key, value in var.hub_virtual_networks : key => merge(value.hub_virtual_network, {
      ddos_protection_plan_id = local.ddos_protection_plan_enabled ? module.ddos_protection_plan[0].resource.id : null
    })
  }
  virtual_network_gateways_express_route = {
    for hub_network_key, hub_network_value in var.hub_virtual_networks : "${hub_network_key}-express-route" => {
      hub_network_key         = hub_network_key
      virtual_network_gateway = hub_network_value.virtual_network_gateways.express_route
    } if can(hub_network_value.virtual_network_gateways.express_route)
  }
  virtual_network_gateways_vpn = {
    for hub_network_key, hub_network_value in var.hub_virtual_networks : "${hub_network_key}-vpn" => {
      hub_network_key         = hub_network_key
      virtual_network_gateway = hub_network_value.virtual_network_gateways.vpn
    } if can(hub_network_value.virtual_network_gateways.vpn)
  }
  virtual_network_gateways = merge(local.virtual_network_gateways_express_route, local.virtual_network_gateways_vpn)
}

locals {
  private_dns_zones = { for key, value in var.hub_virtual_networks : key => merge({
    location = value.hub_virtual_network.location
  }, value.private_dns_zones) if can(value.private_dns_zones.resource_group_name) }

  private_dns_zones_virtual_network_links = {
    for key, value in module.hub_and_spoke_vnet.virtual_networks : key => {
      vnet_resource_id = value.id
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

locals {
  ddos_protection_plan         = can(var.hub_and_spoke_networks_settings.ddos_protection_plan.name) ? var.hub_and_spoke_networks_settings.ddos_protection_plan : null
  ddos_protection_plan_enabled = local.ddos_protection_plan != null
}
