locals {
  management_settings = merge(local.management_settings_custom, var.management_settings)
  management_settings_custom = {
    configure_connectivity_resources = {
      settings = {
        dns = {
          config = {
            location = var.location
          }
        }
      }
      advanced = {
        custom_settings_by_resource_type = {
          azurerm_resource_group = {
            dns = {
              name = local.private_dns_zones_resource_group_name
            }
          }
        }
      }
    }
    configure_management_resources = {
      location = var.location
      advanced = {
        asc_export_resource_group_name = local.management_asc_export_resource_group_name
        custom_settings_by_resource_type = {
          azurerm_resource_group = {
            management = {
              name = local.management_resource_group_name
            }
          }
        }
        azurerm_log_analytics_workspace = {
          management = {
            name = local.management_log_analytics_workspace_name
          }
        }
        azurerm_automation_account = {
          management = {
            name = local.management_automation_account_name
          }
        }
      }
    }
  }
}