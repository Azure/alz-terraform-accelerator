// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for the Management Groups and Subscriptions for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
locals {

  # The following management_group_timeouts and management_group_retries are configured for the lowest level of permissions needed to deploy the landing zone.
  # The lowest level permissions are 'User Access Administrator' at the top level MG, 'Contributor' on the subscriptions, and not a global admin in entra.
  # NOTE: azapi version 2.2.0 or higher will also required setting environment variable AZAPI_RETRY_GET_AFTER_PUT_MAX_TIME to at least "20m" or azapi will stop retrying.

  # Management group timeouts
  management_group_timeouts = {
    management_group = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    }),

    role_definition = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    }),

    policy_definition = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    }),

    policy_set_definition = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    }),

    policy_assignment = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    }),

    policy_role_assignment = ({
      create = "120m"
      delete = "120m"
      update = "120m"
      read   = "120m"
    })
  }

  # Management group retriable errors configuration
  management_group_retries = {
    role_definitions = {
      error_message_regex  = ["The specified role definition with ID '.+' does not exist."]
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    management_groups = {
      error_message_regex  = ["AuthorizationFailed"]
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    policy_assignments = {
      error_message_regex  = ["The policy definition specified in policy assignment '.+' is out of scope", "AuthorizationFailed", "FailedIdentityOperation"]
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    policy_role_assignments = {
      error_message_regex  = ["ResourceNotFound", "AuthorizationFailed", "RoleAssignmentNotFound"]
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    policy_definitions = {
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    policy_set_definitions = {
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    hierarchy_settings = {
      interval_seconds     = 10
      max_interval_seconds = 60
    },
    subscription_placement = {
      error_message_regex  = ["'.+' not found", "Permission to write on resources of type 'Microsoft.Management/managementGroups' is required on the management group or its ancestors."]
      interval_seconds     = 10
      max_interval_seconds = 60
    },
  }

  # Subscription placement
  alz_subscription_placement = {
    management = {
      subscription_id       = var.subscription_id_management
      management_group_name = var.management_management_group_id
    }
    identity = {
      subscription_id       = var.subscription_id_identity
      management_group_name = var.identity_management_group_id
    }
    connectivity = {
      subscription_id       = var.subscription_id_connectivity
      management_group_name = var.connectivity_management_group_id
    }
  }

  management_group_format_variables = {
    default_prefix   = var.default_prefix
    optional_postfix = var.optional_postfix
  }

  platform_management_children_subscription_placement     = { for k, v in var.platform_management_group_children : k => { subscription_id = v.subscription_id, management_group_name = templatestring(v.id, local.management_group_format_variables) } if v.subscription_id != "" }
  landing_zone_management_children_subscription_placement = { for k, v in var.landing_zone_management_group_children : k => { subscription_id = v.subscription_id, management_group_name = templatestring(v.id, local.management_group_format_variables) } if v.subscription_id != "" }
  subscription_placement                                  = merge(local.alz_subscription_placement, local.platform_management_children_subscription_placement, local.landing_zone_management_children_subscription_placement)

  # Telemetry partner ID <PARTNER_ID_UUID>:<PARTNER_DATA_UUID>
  partner_id = format("%s:%s", var.partner_id_uuid, random_uuid.partner_data_uuid.result)

  # Management group information
  az_portal_link                                      = "https://portal.azure.com"
  url_encoded_top_level_management_group_display_name = replace(urlencode(var.top_level_management_group_name), "+", "%20")
  management_group_link                               = "${local.az_portal_link}/#view/Microsoft_Azure_Resources/ManagmentGroupDrilldownMenuBlade/~/overview/tenantId/${var.tenant_id}/mgId/${var.default_prefix}${var.optional_postfix}/mgDisplayName/${local.url_encoded_top_level_management_group_display_name}/mgCanAddOrMoveSubscription~/true/mgParentAccessLevel/Owner/defaultMenuItemId/overview/drillDownMode~/true"
  management_group_info                               = "If you want to learn more about your management group, please click the following link.\n\n${local.management_group_link}\n\n"

  # Management Security Groups
  allowed_security_group_list = ["Owner", "Reader", "Contributor"]
  alz_data                    = jsondecode(file("./lib/architecture_definitions/${var.architecture_name}.alz_architecture_definition.json"))
  management_group_ids = concat(
    # Get the standard management groups from the architecture definition
    [for mg in local.alz_data.management_groups : mg.id]
  )

  owner_builtin_role_definition_id       = "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
  contributor_builtin_role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
  reader_builtin_role_definition_id      = "/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"

  security_group_owner_role_assignments = {
    for k, v in azuread_group.owner_management_group_sg : "${k}-owner" => {
      principal_id       = v.object_id
      scope              = "/providers/Microsoft.Management/managementGroups/${k}"
      role_definition_id = local.owner_builtin_role_definition_id
      description        = "Owner Role Assignment for Security Groups."
    }
  }

  security_group_contributor_role_assignments = {
    for k, v in azuread_group.contributor_management_group_sg : "${k}-contributor" => {
      principal_id       = v.object_id
      scope              = "/providers/Microsoft.Management/managementGroups/${k}"
      role_definition_id = local.contributor_builtin_role_definition_id
      description        = "Contributor Role Assignment for Security Groups."
    }
  }

  security_group_reader_role_assignments = {
    for k, v in azuread_group.reader_management_group_sg : "${k}-reader" => {
      principal_id       = v.object_id
      scope              = "/providers/Microsoft.Management/managementGroups/${k}"
      role_definition_id = local.reader_builtin_role_definition_id
      description        = "Reader Role Assignment for Security Groups."
    }
  }

  security_group_role_assignments = merge(local.security_group_owner_role_assignments, local.security_group_contributor_role_assignments, local.security_group_reader_role_assignments)
}

locals {
  has_placeholder_log_analytics_workspace_resource_id = var.log_analytics_workspace_resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder-la"
  log_analytics_dependent_policy_assignment_names     = toset(["deploy-diag-logscat", "tr-01-logging", "deploy-azactivity-log"]) # include log analytics remediations if log_analytics_workspace_resource_id is set to non-placeholder value

  policy_assignments_files = length(data.alz_metadata.metadata.id) != "" ? fileset(path.root, ".alzlib/*/policy_assignments/*") : toset([]) # alz_metadata check forces ALZ provider to be initialized and .alzlib folder created before local is evaluated
  policy_assignment_name_to_policy_definition_ids = { for file in local.policy_assignments_files : jsondecode(file("${path.root}/${file}")).name => jsondecode(file("${path.root}/${file}")).properties.policyDefinitionId
  if(!local.has_placeholder_log_analytics_workspace_resource_id || !contains(local.log_analytics_dependent_policy_assignment_names, lower(jsondecode(file("${path.root}/${file}")).name))) }

  # Get policy definition reference IDs for built-in policy set definitions
  policy_assignment_name_to_built_in_policy_definition_ids = {
    for policy_assignment_name, policy_definition_id in local.policy_assignment_name_to_policy_definition_ids : policy_assignment_name => policy_definition_id
    if strcontains(policy_definition_id, "policySetDefinitions") && !contains(local.custom_policy_set_definition_ids, policy_definition_id) && can(regex("^([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})$", try(split("/", policy_definition_id)[4], "")))
  }

  policy_assignment_name_to_policy_definition_reference_ids = {
    for policy_assignment_name, built_in_policy_set_definition in data.azapi_resource.built_in_policy_set_definitions :
    policy_assignment_name => [for policy_definition in built_in_policy_set_definition.output.properties.policyDefinitions : policy_definition.policyDefinitionReferenceId]
  }

  policy_assignment_id_with_reference_id_built_ins = flatten([for k, v in module.management_groups.policy_assignment_resource_ids : [for reference_id in local.policy_assignment_name_to_policy_definition_reference_ids[split("/", k)[1]] : "${v}:${reference_id}"]
  if contains(keys(local.policy_assignment_name_to_policy_definition_reference_ids), split("/", k)[1])])

  # Get policy definition reference IDs for custom policy set definitions
  custom_policy_set_definition_filename_to_policy_assignment_name = {
    for policy_assignment_name, policy_definition_id in local.policy_assignment_name_to_policy_definition_ids : "${split("/", policy_definition_id)[length(split("/", policy_definition_id)) - 1]}.alz_policy_set_definition.json" => policy_assignment_name
    if strcontains(policy_definition_id, "policySetDefinitions") && !can(regex("^([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})$", try(split("/", policy_definition_id)[4], "")))
  }

  custom_policy_set_definition_files = length(data.alz_metadata.metadata.id) != "" ? fileset(path.root, ".alzlib/*/policy_set_definitions/*") : toset([])

  custom_policy_set_definition_ids = toset([for file in local.custom_policy_set_definition_files : jsondecode(file("${path.root}/${file}")).id if can(jsondecode(file("${path.root}/${file}")).id)])

  custom_policy_assignment_name_to_policy_definition_reference_ids = {
    for file in local.custom_policy_set_definition_files : local.custom_policy_set_definition_filename_to_policy_assignment_name[basename(file)] => [for policy_definition in jsondecode(file("${path.root}/${file}")).properties.policyDefinitions : policy_definition.policyDefinitionReferenceId]
    if contains(keys(local.custom_policy_set_definition_filename_to_policy_assignment_name), basename(file))
  }

  policy_assignment_id_with_reference_id_custom = flatten([for k, v in module.management_groups.policy_assignment_resource_ids : [for reference_id in local.custom_policy_assignment_name_to_policy_definition_reference_ids[split("/", k)[1]] : "${v}:${reference_id}"
  if reference_id != "migrateToMdeTvm"] if contains(keys(local.custom_policy_assignment_name_to_policy_definition_reference_ids), split("/", k)[1])]) # excluding migrateToMdeTvm remediation, requires intervention in portal to succeed

  policy_assignment_ids_with_reference_id = sort(concat(local.policy_assignment_id_with_reference_id_built_ins, local.policy_assignment_id_with_reference_id_custom))

  # Get policy assignnments with policy definitions
  policy_assignment_name_with_policy_definitions = toset([for policy_assignment_name, policy_definition_id in local.policy_assignment_name_to_policy_definition_ids : lower(policy_assignment_name) if strcontains(policy_definition_id, "policyDefinitions")])

  policy_assignment_name_to_policy_assignment_resource_ids = { for k, v in module.management_groups.policy_assignment_resource_ids : k => v if contains(local.policy_assignment_name_with_policy_definitions, lower(split("/", k)[1])) }
}
