locals {
  virtual_wan_settings_json           = tostring(jsonencode(var.virtual_wan_settings))
  virtual_wan_settings_json_templated = templatestring(local.virtual_wan_settings_json, local.final_replacements)
  virtual_wan_settings_json_final     = replace(replace(replace(replace(local.virtual_wan_settings_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  virtual_wan_settings                = jsondecode(local.virtual_wan_settings_json_final)

  virtual_wan_virtual_hubs_json           = tostring(jsonencode(var.virtual_wan_virtual_hubs))
  virtual_wan_virtual_hubs_json_templated = templatestring(local.virtual_wan_virtual_hubs_json, local.final_replacements)
  virtual_wan_virtual_hubs_json_final     = replace(replace(replace(replace(local.virtual_wan_virtual_hubs_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  virtual_wan_virtual_hubs                = jsondecode(local.virtual_wan_virtual_hubs_json_final)
}
