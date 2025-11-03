locals {
  policy_default_values = { for k, v in try(var.management_group_settings.policy_default_values, {}) : k => (jsonencode(v) == "true" || jsonencode(v) == "false") ? replace(replace(jsonencode({ value = v }), "true", "\"true\""), "false", "\"false\"") : jsonencode({ value = v }) }
  policy_assignments_to_modify = { for management_group_key, management_group_value in try(var.management_group_settings.policy_assignments_to_modify, {}) : management_group_key => {
    policy_assignments = { for policy_assignment_key, policy_assignment_value in try(management_group_value.policy_assignments, {}) : policy_assignment_key => {
      enforcement_mode        = try(policy_assignment_value.enforcement_mode, null)
      identity                = try(policy_assignment_value.identity, null)
      identity_ids            = try(policy_assignment_value.identity_ids, null)
      parameters              = try({ for parameter_key, parameter_value in try(policy_assignment_value.parameters, {}) : parameter_key => local.policy_assignment_parameter_converted[management_group_key][policy_assignment_key][parameter_key] }, null)
      non_compliance_messages = try(policy_assignment_value.non_compliance_messages, null)
      resource_selectors      = try(policy_assignment_value.resource_selectors, null)
      overrides               = try(policy_assignment_value.overrides, null)
    } }
  } }
  policy_assignment_parameter_converted = { for management_group_key, management_group_value in try(var.management_group_settings.policy_assignments_to_modify, {}) : management_group_key => {
    for policy_assignment_key, policy_assignment_value in try(management_group_value.policy_assignments, {}) : policy_assignment_key => {
      for parameter_key, parameter_value in try(policy_assignment_value.parameters, {}) : parameter_key => (jsonencode(parameter_value) == "true" || jsonencode(parameter_value) == "false") ? replace(replace(jsonencode({ value = parameter_value }), "true", "\"true\""), "false", "\"false\"") : jsonencode({ value = parameter_value })
    }
  } }
}
