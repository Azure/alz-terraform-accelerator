data "azapi_client_config" "current" {}

locals {
  management_resource_group_name          = "rg-management-${var.location}"
  management_resource_group_id            = "/subscriptions/${var.subscription_ids["management"]}/resourcegroups/${local.management_resource_group_name}"
  automation_account_name                 = "aa-management-${var.location}"
  log_analytics_workspace_name            = "law-management-${var.location}"
  ama_user_assigned_managed_identity_name = "uami-management-ama-${var.location}"
  dcr_change_tracking_name                = "dcr-change-tracking"
  dcr_defender_sql_name                   = "dcr-defender-sql"
  dcr_vm_insights_name                    = "dcr-vm-insights"

  ama_user_assigned_managed_identity_id       = "${local.management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.ama_user_assigned_managed_identity_name}"
  ama_change_tracking_data_collection_rule_id = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_change_tracking_name}"
  ama_mdfc_sql_data_collection_rule_id        = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_defender_sql_name}"
  ama_vm_insights_data_collection_rule_id     = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_vm_insights_name}"
  log_analytics_workspace_id                  = "${local.management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/${local.log_analytics_workspace_name}"

}

module "management_resources" {
  # <https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest>
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.9.0"

  location                     = var.location
  resource_group_name          = local.management_resource_group_name
  automation_account_name      = local.automation_account_name
  log_analytics_workspace_name = local.log_analytics_workspace_name

  data_collection_rules = {
    "change_tracking" = {
      "name" = local.dcr_change_tracking_name
    }
    "defender_sql" = {
      "name" = local.dcr_defender_sql_name
    }
    "vm_insights" = {
      "name" = local.dcr_vm_insights_name
    }
  }

  user_assigned_managed_identities = {
    ama = {
      name = local.ama_user_assigned_managed_identity_name
    }
  }
}

module "management_groups" {
  # <https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest>
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.14.0"

  architecture_name  = "alz"
  location           = var.location
  parent_resource_id = data.azapi_client_config.current.tenant_id # Tenant root group
  #   retries            = local.default_retries
  #   timeouts           = local.default_timeouts

  dependencies = {
    policy_assignments = [
      module.management_resources.data_collection_rule_ids,
      module.management_resources.resource_id,
      module.management_resources.user_assigned_identity_ids,
    ]
  }

  policy_assignments_to_modify = {
    "alz" = {
      "policy_assignments" = {
        "Deploy-MDFC-Config-H224" = {
          "parameters" = {
            "ascExportResourceGroupLocation"              = jsonencode({ value = var.location })
            "ascExportResourceGroupName"                  = jsonencode({ value = "rg-asc-export-${var.location}" })
            "emailSecurityContact"                        = jsonencode({ value = var.email_security_contact })
            "enableAscForAppServices"                     = jsonencode({ value = "Disabled" })
            "enableAscForArm"                             = jsonencode({ value = "Disabled" })
            "enableAscForContainers"                      = jsonencode({ value = "Disabled" })
            "enableAscForCosmosDbs"                       = jsonencode({ value = "Disabled" })
            "enableAscForCspm"                            = jsonencode({ value = "Disabled" })
            "enableAscForKeyVault"                        = jsonencode({ value = "Disabled" })
            "enableAscForOssDb"                           = jsonencode({ value = "Disabled" })
            "enableAscForServers"                         = jsonencode({ value = "Disabled" })
            "enableAscForServersVulnerabilityAssessments" = jsonencode({ value = "Disabled" })
            "enableAscForSql"                             = jsonencode({ value = "Disabled" })
            "enableAscForSqlOnVm"                         = jsonencode({ value = "Disabled" })
            "enableAscForStorage"                         = jsonencode({ value = "Disabled" })
          }
        }
      }
    }
    "connectivity" = {
      "policy_assignments" = {
        "Enable-DDoS-VNET" = {
          "enforcement_mode" = "DoNotEnforce"
        }
      }
    }
    "corp" = {
      "policy_assignments" = {
        "Deploy-Private-DNS-Zones" = {
          "enforcement_mode" = "DoNotEnforce"
        }
      }
    }
    "landingzones" = {
      "policy_assignments" = {
        "Enable-DDoS-VNET" = {
          "enforcement_mode" = "DoNotEnforce"
        }
      }
    }
  }

  policy_default_values = {
    "ama_user_assigned_managed_identity_name"     = jsonencode({ value = local.ama_user_assigned_managed_identity_name })
    "ama_user_assigned_managed_identity_id"       = jsonencode({ value = local.ama_user_assigned_managed_identity_id })
    "ama_change_tracking_data_collection_rule_id" = jsonencode({ value = local.ama_change_tracking_data_collection_rule_id })
    "ama_mdfc_sql_data_collection_rule_id"        = jsonencode({ value = local.ama_mdfc_sql_data_collection_rule_id })
    "ama_vm_insights_data_collection_rule_id"     = jsonencode({ value = local.ama_vm_insights_data_collection_rule_id })
    "log_analytics_workspace_id"                  = jsonencode({ value = local.log_analytics_workspace_id })
  }

  subscription_placement = {
    "connectivity" = {
      "management_group_name" = "connectivity"
      "subscription_id"       = var.subscription_ids["connectivity"]
    }
    "identity" = {
      "management_group_name" = "identity"
      "subscription_id"       = var.subscription_ids["identity"]
    }
    "management" = {
      "management_group_name" = "management"
      "subscription_id"       = var.subscription_ids["management"]
    }
    # "security" = {
    #   "management_group_name" = "security"
    #   "subscription_id"       = var.subscription_ids["security"]
    # }
  }
}
