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
