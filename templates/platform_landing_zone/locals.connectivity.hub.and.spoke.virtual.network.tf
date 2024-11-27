locals {
  hub_and_spoke_vnet_gateway_default_skus = { for key, value in local.regions : key => length(value.zones) == 0 ? {
    express_route = "Standard"
    vpn           = "VpnGw1"
    } : {
    express_route = "ErGw1AZ"
    vpn           = "VpnGw1AZ"
    }
  }
}

locals {
  hub_and_spoke_vnet_settings_json           = tostring(jsonencode(var.hub_and_spoke_vnet_settings))
  hub_and_spoke_vnet_settings_json_templated = templatestring(local.hub_and_spoke_vnet_settings_json, local.final_replacements)
  hub_and_spoke_vnet_settings_json_final     = replace(replace(local.hub_and_spoke_vnet_settings_json_templated, "\"[", "["), "]\"", "]")
  hub_and_spoke_vnet_settings                = jsondecode(local.hub_and_spoke_vnet_settings_json_final)

  hub_and_spoke_vnet_virtual_networks_json           = tostring(jsonencode(var.hub_and_spoke_vnet_virtual_networks))
  hub_and_spoke_vnet_virtual_networks_json_templated = templatestring(local.hub_and_spoke_vnet_virtual_networks_json, local.final_replacements)
  hub_and_spoke_vnet_virtual_networks_json_final     = replace(replace(local.hub_and_spoke_vnet_virtual_networks_json_templated, "\"[", "["), "]\"", "]")
  hub_and_spoke_vnet_virtual_networks                = local.connectivity_hub_and_spoke_vnet_enabled ? jsondecode(local.hub_and_spoke_vnet_virtual_networks_json_final) : {}
}
