variable "management_resource_settings" {
  type = object({
    automation_account_name      = optional(string)
    location                     = string
    log_analytics_workspace_name = optional(string)
    resource_group_name          = optional(string)
    data_collection_rules = optional(object({
      change_tracking = object({
        enabled  = optional(bool, true)
        name     = string
        location = optional(string)
        tags     = optional(map(string))
      })
      vm_insights = object({
        enabled  = optional(bool, true)
        name     = string
        location = optional(string)
        tags     = optional(map(string))
      })
      defender_sql = object({
        enabled                                                = optional(bool, true)
        name                                                   = string
        location                                               = optional(string)
        tags                                                   = optional(map(string))
        enable_collection_of_sql_queries_for_security_research = optional(bool, false)
      })
    }))
    log_analytics_solution_plans = optional(list(object({
      product   = string
      publisher = optional(string)
    })))
    log_analytics_workspace_allow_resource_only_permissions    = optional(bool, true)
    log_analytics_workspace_cmk_for_query_forced               = optional(bool)
    log_analytics_workspace_daily_quota_gb                     = optional(number)
    log_analytics_workspace_internet_ingestion_enabled         = optional(bool, true)
    log_analytics_workspace_internet_query_enabled             = optional(bool, true)
    log_analytics_workspace_local_authentication_enabled       = optional(bool, true)
    log_analytics_workspace_reservation_capacity_in_gb_per_day = optional(number)
    log_analytics_workspace_retention_in_days                  = optional(number)
    log_analytics_workspace_sku                                = optional(string)
    sentinel_onboarding = optional(object({
      name                         = optional(string)
      customer_managed_key_enabled = optional(bool)
    }))
    tags = optional(map(string))
    timeouts = optional(object({
      sentinel_onboarding = optional(object({
        create = optional(string)
        delete = optional(string)
        update = optional(string)
        read   = optional(string)
      }))
      data_collection_rule = optional(object({
        create = optional(string)
        delete = optional(string)
        update = optional(string)
        read   = optional(string)
      }))
    }), {})
    user_assigned_managed_identities = optional(object({
      ama = object({
        enabled  = optional(bool)
        name     = string
        location = optional(string)
        tags     = optional(map(string))
      })
    }))
  })
  default     = null
  description = <<DESCRIPTION
The settings for the management resources. This object configures the Azure Landing Zone management resources including Log Analytics, Automation Account, and monitoring solutions.

Properties:
- `automation_account_name` - (Optional) The name of the Automation Account.
- `location` - (Required) The Azure region where the management resources will be deployed.
- `log_analytics_workspace_name` - (Optional) The name of the Log Analytics Workspace.
- `resource_group_name` - (Optional) The name of the resource group for management resources.
- `data_collection_rules` - (Optional) Configuration for data collection rules:
  - `change_tracking` - Configuration for change tracking data collection:
    - `enabled` - (Optional) Enable or disable change tracking. Defaults to true.
    - `name` - (Required) The name of the change tracking data collection rule.
    - `location` - (Optional) The Azure region for the data collection rule.
    - `tags` - (Optional) A map of tags to assign to the resource.
  - `vm_insights` - Configuration for VM insights data collection:
    - `enabled` - (Optional) Enable or disable VM insights. Defaults to true.
    - `name` - (Required) The name of the VM insights data collection rule.
    - `location` - (Optional) The Azure region for the data collection rule.
    - `tags` - (Optional) A map of tags to assign to the resource.
  - `defender_sql` - Configuration for Defender for SQL data collection:
    - `enabled` - (Optional) Enable or disable Defender for SQL. Defaults to true.
    - `name` - (Required) The name of the Defender SQL data collection rule.
    - `location` - (Optional) The Azure region for the data collection rule.
    - `tags` - (Optional) A map of tags to assign to the resource.
    - `enable_collection_of_sql_queries_for_security_research` - (Optional) Enable collection of SQL queries for security research. Defaults to false.
- `log_analytics_solution_plans` - (Optional) List of solution plans to deploy to the Log Analytics Workspace:
  - `product` - (Required) The product name of the solution.
  - `publisher` - (Optional) The publisher of the solution.
- `log_analytics_workspace_allow_resource_only_permissions` - (Optional) Allow resource-only permissions for the workspace. Defaults to true.
- `log_analytics_workspace_cmk_for_query_forced` - (Optional) Force customer-managed key for queries.
- `log_analytics_workspace_daily_quota_gb` - (Optional) The daily ingestion quota in GB for the workspace.
- `log_analytics_workspace_internet_ingestion_enabled` - (Optional) Enable internet ingestion for the workspace. Defaults to true.
- `log_analytics_workspace_internet_query_enabled` - (Optional) Enable internet queries for the workspace. Defaults to true.
- `log_analytics_workspace_local_authentication_disabled` - (Optional) Disable local authentication for the workspace. Defaults to false.
- `log_analytics_workspace_reservation_capacity_in_gb_per_day` - (Optional) The reservation capacity in GB per day for the workspace.
- `log_analytics_workspace_retention_in_days` - (Optional) The data retention period in days for the workspace.
- `log_analytics_workspace_sku` - (Optional) The SKU of the Log Analytics Workspace.
- `sentinel_onboarding` - (Optional) Configuration for Microsoft Sentinel onboarding:
  - `name` - (Optional) The name of the Sentinel onboarding configuration.
  - `customer_managed_key_enabled` - (Optional) Enable customer-managed keys for Sentinel.
- `tags` - (Optional) A map of tags to assign to all management resources.
- `timeouts` - (Optional) Timeout configurations for various operations:
  - `sentinel_onboarding` - Timeout settings for Sentinel onboarding operations:
    - `create` - (Optional) Timeout for create operations.
    - `delete` - (Optional) Timeout for delete operations.
    - `update` - (Optional) Timeout for update operations.
    - `read` - (Optional) Timeout for read operations.
  - `data_collection_rule` - Timeout settings for data collection rule operations:
    - `create` - (Optional) Timeout for create operations.
    - `delete` - (Optional) Timeout for delete operations.
    - `update` - (Optional) Timeout for update operations.
    - `read` - (Optional) Timeout for read operations.
- `user_assigned_managed_identities` - (Optional) Configuration for user-assigned managed identities:
  - `ama` - Configuration for Azure Monitor Agent managed identity:
    - `enabled` - (Optional) Enable or disable the managed identity.
    - `name` - (Required) The name of the managed identity.
    - `location` - (Optional) The Azure region for the managed identity.
    - `tags` - (Optional) A map of tags to assign to the resource.

Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/avm-ptn-alz-management
DESCRIPTION
}

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

variable "management_groups_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
Enable or disable the deployment of management groups.

When set to `true`, the management group hierarchy will be created and configured according to the `management_group_settings` variable.
When set to `false`, no management groups will be deployed.

Defaults to `true`.
DESCRIPTION
}

variable "management_resources_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
Enable or disable the deployment of management resources.

When set to `true`, management resources such as Log Analytics Workspace, Automation Account, and monitoring solutions will be deployed according to the `management_resource_settings` variable.
When set to `false`, no management resources will be deployed.

Defaults to `true`.
DESCRIPTION
}
