locals {
  config     = yamldecode(file("${path.module}/config.yaml"))
  archetypes = local.config.archetypes
  hub_virtual_networks = {
    for k, v in local.config.connectivity.hubnetworking.hub_virtual_networks : k => {
      for k2, v2 in v : k2 => v2 if k2 != "virtual_network_gateway"
    }
  }
  vritual_network_gateways = {
    for k, v in local.config.connectivity.hubnetworking.hub_virtual_networks : k => merge(
      v.virtual_network_gateway,
      {
        location                            = v.location
        virtual_network_name                = v.name
        virtual_network_resource_group_name = v.resource_group_name
      }
    )
  }
  dummy_hub_virtual_network = {
    hub = {
      name                = "dummy"
      address_space       = ["0.0.0.0/0"]
      location            = "dummy"
      resource_group_name = "dummy"
    }
  }
}
