locals {
  management_resource_settings_json           = tostring(jsonencode(var.management_resource_settings))
  management_resource_settings_json_templated = templatestring(local.management_resource_settings_json, local.final_replacements)
  management_resource_settings_json_final     = replace(replace(local.management_resource_settings_json_templated, "\"[", "["), "]\"", "]")
  management_resource_settings                = jsondecode(local.management_resource_settings_json_final)
}

locals {
  management_group_settings_json           = tostring(jsonencode(var.management_group_settings))
  management_group_settings_json_templated = templatestring(local.management_group_settings_json, local.final_replacements)
  management_group_settings_json_final     = replace(replace(local.management_group_settings_json_templated, "\"[", "["), "]\"", "]")
  management_group_settings                = jsondecode(local.management_group_settings_json_final)
}

locals {
  management_group_dependencies = {
    policy_assignments = [
      module.management_resources,
      module.hub_and_spoke_vnet,
      module.virtual_wan
    ]
    policy_role_assignments = [
      module.management_resources,
      module.hub_and_spoke_vnet,
      module.virtual_wan
    ]
  }
}
