// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the Management Groups and Subscriptions for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
resource "random_uuid" "partner_data_uuid" {
}

module "management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.11.0"

  parent_resource_id     = var.root_parent_management_group_id
  architecture_name      = var.architecture_name
  location               = var.location
  enable_telemetry       = var.enable_telemetry
  policy_default_values  = var.policy_default_values
  partner_id             = local.partner_id
  timeouts               = local.management_group_timeouts
  retries                = local.management_group_retries
  subscription_placement = local.subscription_placement
}

resource "azuread_group" "owner_management_group_sg" {
  for_each         = contains(var.default_security_groups, "Owner") ? toset(local.management_group_ids) : []
  display_name     = "sg-${each.key}-owner" # Change to naming convention
  description      = "Owner security Group for ${each.key}"
  security_enabled = true
}

resource "azuread_group" "contributor_management_group_sg" {
  for_each         = contains(var.default_security_groups, "Contributor") ? toset(local.management_group_ids) : []
  display_name     = "sg-${each.key}-contributor" # Change to naming convention
  description      = "Contributor security Group for ${each.key}"
  security_enabled = true
}

resource "azuread_group" "reader_management_group_sg" {
  for_each         = contains(var.default_security_groups, "Reader") ? toset(local.management_group_ids) : []
  display_name     = "sg-${each.key}-reader" # Change to naming convention
  description      = "Reader security Group for ${each.key}"
  security_enabled = true
}

resource "azapi_resource" "policy_role_assignments" {
  for_each = local.security_group_role_assignments

  type = "Microsoft.Authorization/roleAssignments@2022-04-01"
  body = {
    properties = {
      principalId      = each.value.principal_id
      roleDefinitionId = each.value.role_definition_id
      description      = each.value.description
      principalType    = "Group"
    }
  }
  name      = uuidv5("url", "${each.value.scope}${each.value.role_definition_id}")
  parent_id = each.value.scope
  retry     = local.management_group_retries.policy_role_assignments

  timeouts {
    create = local.management_group_timeouts.policy_role_assignment.create
    delete = local.management_group_timeouts.policy_role_assignment.delete
    update = local.management_group_timeouts.policy_role_assignment.update
    read   = local.management_group_timeouts.policy_role_assignment.read
  }

  depends_on = [module.management_groups]
}

module "default_exemption" {
  source = "../policy_exemption"

  policy_exemptions = var.default_policy_exemptions

  depends_on = [module.management_groups]
}

module "policy_remediation" {
  source = "../policy_remediation"

  policy_assignment_ids_with_reference_id                  = local.policy_assignment_ids_with_reference_id
  policy_assignment_name_to_policy_assignment_resource_ids = local.policy_assignment_name_to_policy_assignment_resource_ids

  depends_on = [module.default_exemption]
}
