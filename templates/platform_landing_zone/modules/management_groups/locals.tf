locals {
  policy_default_values = { for k, v in try(var.management_group_settings.policy_default_values, {}) : k => jsonencode({
    value = v
  }) }
  policy_assignments_to_modify = { for management_group_key, management_group_value in try(var.management_group_settings.policy_assignments_to_modify, {}) : management_group_key => {
    policy_assignments = { for policy_assignment_key, policy_assignment_value in management_group_value.policy_assignments : policy_assignment_key => {
      enforcement_mode        = try(policy_assignment_value.enforcement_mode, null)
      identity                = try(policy_assignment_value.identity, null)
      identity_ids            = try(policy_assignment_value.identity_ids, null)
      parameters              = try({ for parameter_key, parameter_value in policy_assignment_value.parameters : parameter_key => jsonencode({ value = parameter_value }) }, null)
      non_compliance_messages = try(policy_assignment_value.non_compliance_messages, null)
      resource_selectors      = try(policy_assignment_value.resource_selectors, null)
      overrides               = try(policy_assignment_value.overrides, null)
    } }
  } }
  default_retries = {
    management_groups = {
      error_message_regex = ["AuthorizationFailed", "Permission to Microsoft.Management/managementGroups on resources of type 'Write' is required on the management group or its ancestors."]
    }
    role_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_set_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_assignments = {
      error_message_regex = ["AuthorizationFailed", "The policy definition specified in policy assignment '.+' is out of scope"]
    }
    policy_role_assignments = {
      error_message_regex = ["AuthorizationFailed", "ResourceNotFound", "RoleAssignmentNotFound"]
    }
    hierarchy_settings = {
      error_message_regex = ["AuthorizationFailed"]
    }
    subscription_placement = {
      error_message_regex = ["AuthorizationFailed"]
    }
  }
  default_timeouts = {
    management_group = {
      create = "60m"
      read   = "60m"
    }
    role_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_assignment = {
      create = "60m"
      read   = "60m"
    }
    policy_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_set_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_role_assignment = {
      create = "60m"
      read   = "60m"
    }
  }
}
