locals {
  virtual_wan_settings_json           = tostring(jsonencode(var.virtual_wan_settings))
  virtual_wan_settings_json_templated = templatestring(local.virtual_wan_settings_json, local.config_template_file_variables)
  virtual_wan_settings_json_final     = replace(replace(local.virtual_wan_settings_json_templated, "\"[", "["), "]\"", "]")
  virtual_wan_settings                = local.connectivity_virtual_wan_enabled ? jsondecode(local.virtual_wan_settings_json_final) : null

  virtual_wan_virtual_hubs_json           = tostring(jsonencode(var.virtual_wan_virtual_hubs))
  virtual_wan_virtual_hubs_json_templated = templatestring(local.virtual_wan_virtual_hubs_json, local.config_template_file_variables)
  virtual_wan_virtual_hubs_json_final     = replace(replace(local.virtual_wan_virtual_hubs_json_templated, "\"[", "["), "]\"", "]")
  virtual_wan_virtual_hubs                = local.connectivity_virtual_wan_enabled ? jsondecode(local.virtual_wan_virtual_hubs_json_final) : {}
}
