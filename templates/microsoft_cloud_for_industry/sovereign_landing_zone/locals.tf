// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the locals block for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
locals {
  default_location = var.starter_locations[0]
}

locals {
  architecture_name               = "slz"
  dashboard_name                  = "Sovereign-Landing-Zone-Dashboard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  root_parent_management_group_id = var.root_parent_management_group_id == "" ? local.tenant_id : var.root_parent_management_group_id
  uami_name                       = "uami-ama"

  slz_policy_default_values = {
    slz_policy_effect                            = jsonencode({ value = var.policy_effect })
    list_of_allowed_locations                    = jsonencode({ value = var.allowed_locations })
    allowed_locations_for_confidential_computing = jsonencode({ value = var.allowed_locations_for_confidential_computing })
    ddos_protection_plan_id                      = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder" })
    ddos_protection_plan_effect                  = jsonencode({ value = var.deploy_ddos_protection ? "Audit" : "Disabled" })
    email_security_contact                       = jsonencode({ value = var.ms_defender_for_cloud_email_security_contact })
    ama_user_assigned_managed_identity_id        = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.uami_name}" })
    ama_user_assigned_managed_identity_name      = jsonencode({ value = local.uami_name })
    log_analytics_workspace_id                   = jsonencode({ value = var.log_analytics_workspace_resource_id })
  }

  partner_id_uuid = "2c12b9d4-df50-4186-bd31-ae6686b633d2" # static uuid generated for SLZ
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
  management_group_resource_id_format = "/providers/Microsoft.Management/managementGroups/%s"

  management_group_format_variables = {
    default_prefix   = var.default_prefix
    optional_postfix = var.optional_postfix
  }

  root_management_group_id                = templatestring(var.management_group_configuration.root.id, local.management_group_format_variables)
  management_management_group_id          = templatestring(var.management_group_configuration.management.id, local.management_group_format_variables)
  connectivity_management_group_id        = templatestring(var.management_group_configuration.connectivity.id, local.management_group_format_variables)
  identity_management_group_id            = templatestring(var.management_group_configuration.identity.id, local.management_group_format_variables)
  confidential_corp_management_group_id   = templatestring(var.management_group_configuration.confidential_corp.id, local.management_group_format_variables)
  confidential_online_management_group_id = templatestring(var.management_group_configuration.confidential_online.id, local.management_group_format_variables)

  top_level_management_group_name                  = var.management_group_configuration.root.display_name
  sovereign_global_policy_assignment_resource_id   = format(local.management_group_resource_id_format, "${local.root_management_group_id}/providers/microsoft.authorization/policyassignments/enforce-sovereign-global")
  confidential_online_management_group_resource_id = format(local.management_group_resource_id_format, local.confidential_online_management_group_id)
  confidential_corp_management_group_resource_id   = format(local.management_group_resource_id_format, local.confidential_corp_management_group_id)

  # Policy exemptions
  default_policy_exemptions = {
    "Confidential-Online-Global-Location-Exemption" = {
      name                            = "Confidential-Online-Global-Location-Exemption"
      display_name                    = "Confidential-Online-Global-Location-Exemption"
      description                     = "Exempt the confidential online management group from the SLZ Global location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_online_management_group_resource_id
      policy_assignment_id            = local.sovereign_global_policy_assignment_resource_id
      policy_definition_reference_ids = ["AllowedLocationsForResourceGroups", "AllowedLocations"]
      exemption_category              = "Waiver"
    }
    "Confidential-Corp-Global-Location-Exemption" = {
      name                            = "Confidential-Corp-Global-Location-Exemption"
      display_name                    = "Confidential-Corp-Global-Location-Exemption"
      description                     = "Exempt the confidential corp management group from the SLZ Global Policies location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_corp_management_group_resource_id
      policy_assignment_id            = local.sovereign_global_policy_assignment_resource_id
      policy_definition_reference_ids = ["AllowedLocationsForResourceGroups", "AllowedLocations"]
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
}
