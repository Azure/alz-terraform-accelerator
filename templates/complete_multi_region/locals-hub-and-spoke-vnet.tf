locals {
  hub_and_spoke_vnet_gateway_default_skus = { for key, value in local.regions : key => length(value.zones) == 0 ? {
    express_route = "Standard"
    vpn           = "VpnGw1"
    } : {
    express_route = "ErGw1AZ"
    vpn           = "VpnGw1AZ"
    }
  }

  hub_and_spoke_vnet_virtual_networks_with_default_gateway_skus = { for key, value in var.hub_and_spoke_vnet_virtual_networks : key => merge(
    can(value.virtual_network_gateways.express_route) ? {
    virtual_network_gateways = {
      express_route = {
        sku = local.hub_and_spoke_vnet_gateway_default_skus[key].express_route
      }
    }}: {},
    can(value.virtual_network_gateways.vpn) ? {
    virtual_network_gateways = {
      vpn = {
        sku = local.hub_and_spoke_vnet_gateway_default_skus[key].vpn
      }
    }} : {},
    var.hub_and_spoke_vnet_virtual_networks)
  }
}

locals {
  hub_and_spoke_vnet_settings_json           = tostring(jsonencode(var.hub_and_spoke_vnet_settings))
  hub_and_spoke_vnet_settings_json_templated = templatestring(local.hub_and_spoke_vnet_settings_json, local.config_template_file_variables)
  hub_and_spoke_vnet_settings_json_final     = replace(replace(local.hub_and_spoke_vnet_settings_json_templated, "\"[", "["), "]\"", "]")
  hub_and_spoke_vnet_settings                = jsondecode(local.hub_and_spoke_vnet_settings_json_final)

  hub_and_spoke_vnet_virtual_networks_json           = tostring(jsonencode(local.hub_and_spoke_vnet_virtual_networks_with_default_gateway_skus))
  hub_and_spoke_vnet_virtual_networks_json_templated = templatestring(local.hub_and_spoke_vnet_virtual_networks_json, local.config_template_file_variables)
  hub_and_spoke_vnet_virtual_networks_json_final     = replace(replace(local.hub_and_spoke_vnet_virtual_networks_json_templated, "\"[", "["), "]\"", "]")
  hub_and_spoke_vnet_virtual_networks       = local.connectivity_hub_and_spoke_vnet_enabled ? jsondecode(local.hub_and_spoke_vnet_virtual_networks_json_final) : {}
}
