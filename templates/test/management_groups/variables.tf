variable "management_group_settings" {
  type = object({
    architecture_name            = optional(string, "alz_custom")
    parent_resource_id           = string
    location                     = string
    policy_default_values        = optional(any)
    policy_assignments_to_modify = optional(any)
    management_group_hierarchy_settings = optional(object({
      default_management_group_name            = string
      require_authorization_for_group_creation = optional(bool, true)
      update_existing                          = optional(bool, false)
    }))
    partner_id = optional(string)
    retries = optional(object({
      management_groups = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      role_definitions = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      role_assignments = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      policy_definitions = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      policy_set_definitions = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      policy_assignments = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      policy_role_assignments = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      hierarchy_settings = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
      subscription_placement = optional(object({
        error_message_regex  = optional(list(string))
        interval_seconds     = optional(number)
        max_interval_seconds = optional(number)
        multiplier           = optional(number)
        randomization_factor = optional(number)
      }))
    }), {})
    subscription_placement = optional(map(object({
      subscription_id       = string
      management_group_name = string
    })))
    timeouts = optional(object({
      management_group = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      role_definition = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      role_assignment = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      policy_definition = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      policy_set_definition = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      policy_assignment = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
      policy_role_assignment = optional(object({
        create = optional(string, "60m")
        delete = optional(string, "60m")
        update = optional(string, "60m")
        read   = optional(string, "60m")
      }), {})
    }), {})
    dependencies = optional(object({
      policy_role_assignments = optional(any)
      policy_assignments      = optional(any)
    }))
    override_policy_definition_parameter_assign_permissions_set = optional(set(object({
      definition_name = string
      parameter_name  = string
    })))
    override_policy_definition_parameter_assign_permissions_unset = optional(set(object({
      definition_name = string
      parameter_name  = string
    })))
    management_group_role_assignments = optional(map(object({
      management_group_name                  = string
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      principal_type                         = optional(string)
    })))
    role_assignment_definition_lookup_enabled = optional(bool, true)
    policy_assignment_non_compliance_message_settings = optional(object({
      fallback_message_enabled                 = optional(bool)
      fallback_message                         = optional(string)
      fallback_message_unsupported_assignments = optional(list(string))
      enforcement_mode_placeholder             = optional(string)
      enforced_replacement                     = optional(string)
      not_enforced_replacement                 = optional(string)
    }))
    role_assignment_name_use_random_uuid = optional(bool, true)
  })
  default     = null
  description = <<DESCRIPTION
The settings for the management groups. This object configures the Azure Landing Zone management group hierarchy, policies, and role assignments.

Properties:
- `architecture_name` - (Optional) The name of the architecture definition to use. Defaults to "alz_custom".
- `parent_resource_id` - (Required) The resource ID of the parent management group.
- `location` - (Required) The default Azure region for resources.
- `policy_default_values` - (Optional) A map of default values for policy parameters.
- `policy_assignments_to_modify` - (Optional) Map of policy assignments to modify:
  - `policy_assignments` - Map of policy assignment modifications:
    - `enforcement_mode` - (Optional) The enforcement mode for the policy assignment.
    - `identity` - (Optional) The type of managed identity for the policy assignment.
    - `identity_ids` - (Optional) List of user-assigned identity resource IDs.
    - `parameters` - (Optional) Map of parameter values for the policy assignment.
    - `non_compliance_messages` - (Optional) Set of non-compliance messages:
      - `message` - (Required) The non-compliance message.
      - `policy_definition_reference_id` - (Optional) The policy definition reference ID.
    - `resource_selectors` - (Optional) List of resource selectors:
      - `name` - (Required) The name of the resource selector.
      - `resource_selector_selectors` - (Optional) List of selector criteria:
        - `kind` - (Required) The kind of selector.
        - `in` - (Optional) Set of values to include.
        - `not_in` - (Optional) Set of values to exclude.
    - `overrides` - (Optional) List of policy overrides:
      - `kind` - (Required) The kind of override.
      - `value` - (Required) The override value.
      - `override_selectors` - (Optional) List of override selectors:
        - `kind` - (Required) The kind of selector.
        - `in` - (Optional) Set of values to include.
        - `not_in` - (Optional) Set of values to exclude.
- `management_group_hierarchy_settings` - (Optional) Settings for the management group hierarchy:
  - `default_management_group_name` - (Required) The name of the default management group.
  - `require_authorization_for_group_creation` - (Optional) Require authorization for management group creation. Defaults to true.
  - `update_existing` - (Optional) Update existing management groups. Defaults to false.
- `partner_id` - (Optional) The partner ID for Azure partner attribution.
- `retries` - (Optional) Retry configurations for various resource types:
  - `management_groups`, `role_definitions`, `role_assignments`, `policy_definitions`, `policy_set_definitions`, `policy_assignments`, `policy_role_assignments`, `hierarchy_settings`, `subscription_placement` - Each has the following retry settings:
    - `error_message_regex` - (Optional) List of regex patterns to match error messages for retry.
    - `interval_seconds` - (Optional) The initial retry interval in seconds.
    - `max_interval_seconds` - (Optional) The maximum retry interval in seconds.
    - `multiplier` - (Optional) The multiplier for exponential backoff.
    - `randomization_factor` - (Optional) The randomization factor for retry intervals.
- `subscription_placement` - (Optional) Map of subscription placement configurations:
  - `subscription_id` - (Required) The subscription ID to place.
  - `management_group_name` - (Required) The target management group name.
- `timeouts` - (Optional) Timeout configurations for various resource types:
  - `management_group`, `role_definition`, `role_assignment`, `policy_definition`, `policy_set_definition`, `policy_assignment`, `policy_role_assignment` - Each has the following timeout settings:
    - `create` - (Optional) Timeout for create operations.
    - `delete` - (Optional) Timeout for delete operations.
    - `update` - (Optional) Timeout for update operations.
    - `read` - (Optional) Timeout for read operations.
- `dependencies` - (Optional) Dependency configurations:
  - `policy_role_assignments` - (Optional) Dependencies for policy role assignments.
  - `policy_assignments` - (Optional) Dependencies for policy assignments.
- `override_policy_definition_parameter_assign_permissions_set` - (Optional) Set of policy definition parameters to assign permissions:
  - `definition_name` - (Required) The policy definition name.
  - `parameter_name` - (Required) The parameter name.
- `override_policy_definition_parameter_assign_permissions_unset` - (Optional) Set of policy definition parameters to unset permissions:
  - `definition_name` - (Required) The policy definition name.
  - `parameter_name` - (Required) The parameter name.
- `management_group_role_assignments` - (Optional) Map of management group role assignments:
  - `management_group_name` - (Required) The target management group name.
  - `role_definition_id_or_name` - (Required) The role definition ID or name.
  - `principal_id` - (Required) The principal ID to assign the role to.
  - `description` - (Optional) Description of the role assignment.
  - `skip_service_principal_aad_check` - (Optional) Skip service principal AAD check. Defaults to false.
  - `condition` - (Optional) The condition for the role assignment.
  - `condition_version` - (Optional) The condition version.
  - `delegated_managed_identity_resource_id` - (Optional) The delegated managed identity resource ID.
  - `principal_type` - (Optional) The type of principal.
- `role_assignment_definition_lookup_enabled` - (Optional) Enable role definition lookup for assignments. Defaults to true.
- `policy_assignment_non_compliance_message_settings` - (Optional) Settings for policy non-compliance messages:
  - `fallback_message_enabled` - (Optional) Enable fallback messages.
  - `fallback_message` - (Optional) The fallback message text.
  - `fallback_message_unsupported_assignments` - (Optional) List of unsupported assignment names.
  - `enforcement_mode_placeholder` - (Optional) Placeholder for enforcement mode.
  - `enforced_replacement` - (Optional) Replacement text for enforced mode.
  - `not_enforced_replacement` - (Optional) Replacement text for not enforced mode.
- `role_assignment_name_use_random_uuid` - (Optional) Use random UUID for role assignment names. Defaults to true.

Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/avm-ptn-alz
DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}
