// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the locals block for the Cloud for Financial Services
AUTHOR/S: Cloud for Financial Services
*/
locals {
  default_location             = var.starter_locations[0]
  subscription_id_management   = module.bootstrap.subscription_id_management
  subscription_id_connectivity = module.bootstrap.subscription_id_connectivity
  subscription_id_identity     = module.bootstrap.subscription_id_identity
}

locals {
  architecture_name                       = "fsi"
  management_group_top_level_display_name = "FSI Landing Zone"
  dashboard_name                          = "financial-services-industry-dashboard"
  tenant_id                               = data.azurerm_client_config.current.tenant_id
  root_parent_management_group_id         = var.root_parent_management_group_id == "" ? local.tenant_id : var.root_parent_management_group_id

  fsi_policy_default_values = {
    policyEffect                             = jsonencode({ value = var.policy_effect })
    allowedLocationsForConfidentialComputing = jsonencode({ value = var.allowed_locations_for_confidential_computing })
    allowedLocations                         = jsonencode({ value = var.allowed_locations })
    ddosProtectionPlanId                     = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder" })
    ddosProtectionPlanEffect                 = jsonencode({ value = var.deploy_ddos_protection ? "Audit" : "Disabled" })
    emailSecurityContact                     = jsonencode({ value = var.ms_defender_for_cloud_email_security_contact })
    logAnalyticsWorkspaceId                  = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder-la" })
  }

  partner_id_uuid = "2a6b78e2-b391-4dcd-bac6-9906ea017198" # static telemetry partner uuid generated for FSI
}


locals {
  log_analytics_workspace_solutions = [
    {
      "product" : "OMSGallery/AgentHealthAssessment",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/AntiMalware",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/ChangeTracking",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/Security",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/ServiceMap",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/SQLAssessment",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/Updates",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/VMInsights",
      "publisher" : "Microsoft"
    }
  ]
}

locals {
  management_group_resource_id_format     = "/providers/Microsoft.Management/managementGroups/%s"
  root_management_group_id                = format(local.management_group_resource_id_format, "${var.default_prefix}${var.default_postfix}")
  confidential_corp_management_group_id   = format(local.management_group_resource_id_format, "${var.default_prefix}-landingzones-confidential-corp${var.default_postfix}")
  confidential_online_management_group_id = format(local.management_group_resource_id_format, "${var.default_prefix}-landingzones-confidential-online${var.default_postfix}")

  # Policy exemptions
  default_policy_exemptions = {
    "Confidential-Online-Data-Residency-Exemption" = {
      name                            = "Confidential-Online-Data-Residency-Exemption"
      display_name                    = "Confidential-Online-Data-Residency-Exemption"
      description                     = "Exempt the confidential online management group from the FSI data residency location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_online_management_group_id
      policy_assignment_id            = "${local.root_management_group_id}/providers/microsoft.authorization/policyassignments/so-01-data-residency"
      policy_definition_reference_ids = ["Allowed locations for resource groups", "Allowed locations"]
      exemption_category              = "Waiver"
    }
    "Confidential-Corp-Data-Residency-Exemption" = {
      name                            = "Confidential-Corp-Data-Residency-Exemption"
      display_name                    = "Confidential-Corp-Data-Residency-Exemption"
      description                     = "Exempt the confidential corp management group from the FSI data residency location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_corp_management_group_id
      policy_assignment_id            = "${local.root_management_group_id}/providers/microsoft.authorization/policyassignments/so-01-data-residency"
      policy_definition_reference_ids = ["Allowed locations for resource groups", "Allowed locations"]
      exemption_category              = "Waiver"
    }
  }

  custom_policy_exemptions = { for v in var.policy_exemptions : v.name => {
    name                            = v.name
    display_name                    = v.display_name
    description                     = v.description
    management_group_id             = v.management_group_id
    policy_assignment_id            = v.policy_assignment_id
    policy_definition_reference_ids = v.policy_definition_reference_ids
    exemption_category              = v.exemption_category
    }
  }

  policy_exemptions          = merge(local.default_policy_exemptions, local.custom_policy_exemptions)
  policy_set_definition_name = ["deploy-diag-logs", "deploy-mdfc-config-h224", "tr-01-logging"]
}
