locals {
  management_settings_es_json           = tostring(jsonencode(var.management_settings_es))
  management_settings_es_json_templated = templatestring(local.management_settings_es_json, local.config_template_file_variables)
  management_settings_es_json_final     = replace(replace(local.management_settings_es_json_templated, "\"[", "["), "]\"", "]")
  management_settings_es                = jsondecode(local.management_settings_es_json_final)
}

locals {
  management_settings_avm_json           = tostring(jsonencode(var.management_settings_avm))
  management_settings_avm_json_templated = templatestring(local.management_settings_avm_json, local.config_template_file_variables)
  management_settings_avm_json_final     = replace(replace(local.management_settings_avm_json_templated, "\"[", "["), "]\"", "]")
  management_settings_avm                = jsondecode(local.management_settings_avm_json_final)
}
