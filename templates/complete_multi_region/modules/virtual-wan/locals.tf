locals {
  virtual_hubs = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => virtual_hub_value.hub }
}

locals {
  virtual_network_connections_input = { for virtual_network_connection in flatten([for virtual_hub_key, virtual_hub_value in var.virtual_hubs :
    [for virtual_network_connection_key, virtual_network_connection_value in try(virtual_hub_value.virtual_network_connections, {}) : {
      unique_key                = "${virtual_hub_key}-${virtual_network_connection_key}"
      name                      = virtual_network_connection_value.settings.name
      virtual_hub_key           = virtual_hub_key
      remote_virtual_network_id = virtual_network_connection_value.remote_virtual_network_id
      settings                  = virtual_network_connection_value.settings
    }]
    ]) : virtual_network_connection.unique_key => {
    name                      = virtual_network_connection.name
    virtual_hub_key           = virtual_network_connection.virtual_hub_key
    remote_virtual_network_id = virtual_network_connection.remote_virtual_network_id
    settings                  = virtual_network_connection.settings
  } }

  virtual_network_connections_private_dns = { for key, value in local.private_dns_zones : "private_dns_vnet_${key}" => {
    name                      = "private_dns_vnet_${key}"
    virtual_hub_key           = key
    remote_virtual_network_id = module.virtual_network_private_dns[key].resource_id
  } }

  virtual_network_connections = merge(local.virtual_network_connections_input, local.virtual_network_connections_private_dns)
}

locals {
  firewall_policies = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge({
    location            = try(virtual_hub_value.firewall.firewall_policy.location, virtual_hub_value.hub.location)
    resource_group_name = try(virtual_hub_value.firewall.firewall_policy.resource_group_name, virtual_hub_value.hub.resource_group_name)
    dns = {
      servers       = [module.dns_resolver[virtual_hub_key].inbound_endpoint_ips["dns"]]
      proxy_enabled = true
    }
  }, virtual_hub_value.firewall.firewall_policy) if can(virtual_hub_value.firewall_policy) }

  firewalls = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge(
    {
      virtual_hub_key    = virtual_hub_key
      location           = try(virtual_hub_value.firewall.location, virtual_hub_value.hub.location)
      firewall_policy_id = module.firewall_policy[virtual_hub_key].resource_id
    }, virtual_hub_value.firewall)
    if can(virtual_hub_value.firewall)
  }
}

locals {
  private_dns_zones = { for key, value in var.virtual_hubs : key => merge({
    location = value.hub.location
  }, value.private_dns_zones) if can(value.private_dns_zones.resource_group_name) }

  private_dns_zones_virtual_network_links = {
    for key, value in module.virtual_network_private_dns : key => {
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

locals {
  ddos_protection_plan         = can(var.virtual_wan_settings.ddos_protection_plan.name) ? var.virtual_wan_settings.ddos_protection_plan : null
  ddos_protection_plan_enabled = local.ddos_protection_plan != null
}
