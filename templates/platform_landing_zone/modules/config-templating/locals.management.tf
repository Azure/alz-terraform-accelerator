locals {
  management_resource_settings_json           = tostring(jsonencode(var.management_resource_settings))
  management_resource_settings_json_templated = templatestring(local.management_resource_settings_json, local.final_replacements)
  management_resource_settings_json_final     = replace(replace(replace(replace(local.management_resource_settings_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  management_resource_settings                = jsondecode(local.management_resource_settings_json_final)
}

locals {
  management_group_settings_json           = tostring(jsonencode(var.management_group_settings))
  management_group_settings_json_templated = templatestring(local.management_group_settings_json, local.final_replacements)
  management_group_settings_json_final     = replace(replace(replace(replace(local.management_group_settings_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  management_group_settings                = jsondecode(local.management_group_settings_json_final)
}
