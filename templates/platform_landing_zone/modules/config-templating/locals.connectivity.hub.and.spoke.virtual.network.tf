locals {
  hub_and_spoke_networks_settings_json           = tostring(jsonencode(var.hub_and_spoke_networks_settings))
  hub_and_spoke_networks_settings_json_templated = templatestring(local.hub_and_spoke_networks_settings_json, local.final_replacements)
  hub_and_spoke_networks_settings_json_final     = replace(replace(replace(replace(local.hub_and_spoke_networks_settings_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  hub_and_spoke_networks_settings                = jsondecode(local.hub_and_spoke_networks_settings_json_final)

  hub_virtual_networks_json           = tostring(jsonencode(var.hub_virtual_networks))
  hub_virtual_networks_json_templated = templatestring(local.hub_virtual_networks_json, local.final_replacements)
  hub_virtual_networks_json_final     = replace(replace(replace(replace(local.hub_virtual_networks_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  hub_virtual_networks                = jsondecode(local.hub_virtual_networks_json_final)
}
