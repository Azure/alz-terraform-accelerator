locals {
  management_settings_es_json           = var.skip_deploy ? jsonencode({}) : jsonencode(var.management_settings_es)
  management_settings_es_json_templated = templatestring(local.management_settings_es_json, local.final_replacements)
  management_settings_es_json_final     = replace(replace(local.management_settings_es_json_templated, "\"[", "["), "]\"", "]")
  management_settings_es                = jsondecode(local.management_settings_es_json_final)
}
