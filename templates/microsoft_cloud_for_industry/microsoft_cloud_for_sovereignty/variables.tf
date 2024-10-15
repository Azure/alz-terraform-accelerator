// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for the Sovereign Landing Zone Depoloyment
AUTHOR/S: Cloud for Sovereignty
*/
variable "default_location" {
  type        = string
  description = "Location used for deploying Azure resources. (e.g 'uksouth')|azure_location"
}

variable "default_prefix" {
  type        = string
  default     = "mcfs"
  description = "Prefix added to all Azure resources created by the SLZ. (e.g 'mcfs')"
  validation {
    condition     = length(var.default_prefix) >= 2 && length(var.default_prefix) <= 5
    error_message = "The prefix must be between 2 and 5 characters long."
  }
}

variable "default_postfix" {
  type        = string
  default     = ""
  description = "The deployment postfix for Azure resources. (e.g 'dev')"
  validation {
    condition     = length(var.default_postfix) >= 0 && length(var.default_postfix) <= 5
    error_message = "The prefix must be between 0 and 5 characters long."
  }
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "(Optional) parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty (default) will deploy beneath Tenant Root Management Group. (e.g 'mcfs')|azure_name"
}


variable "subscription_billing_scope" {
  type        = string
  default     = ""
  description = "The subscription billing scope. (e.g '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456')"
}

variable "customer" {
  type        = string
  default     = "Country/Region"
  description = "The name of the organization deploying the SLZ to brand the compliance dashboard appropriately. (e.g 'Country/Region')"
}

variable "allowed_locations" {
  type        = set(string)
  default     = []
  description = "Full list of Azure regions allowed by policy where resources can be deployed that should include at least the deployment location. (e.g ['eastus'])"
  validation {
    condition = alltrue([
      for location in var.allowed_locations : contains(local.allowed_locations_list, location)
    ])
    error_message = "The deployment location must be one of the allowed values."
  }
}

variable "allowed_locations_for_confidential_computing" {
  type        = set(string)
  default     = []
  description = "Full list of Azure regions allowed by policy where Confidential computing resources can be deployed. This may be a completely different list from allowed_locations. (e.g ['eastus'])"
  validation {
    condition = alltrue([
      for location in var.allowed_locations_for_confidential_computing : contains(local.allowed_locations_for_confidential_computing_list, location)
    ])
    error_message = "The deployment location of confidential computing resources must be one of the allowed values."
  }
}

variable "deploy_ddos_protection" {
  type        = bool
  default     = true
  description = "Toggles deployment of Azure DDOS protection. True to deploy, otherwise false. (e.g true)"
}

variable "deploy_hub_network" {
  type        = bool
  default     = true
  description = "Toggles deployment of the hub VNET. True to deploy, otherwise false. (e.g true)"
}

variable "enable_firewall" {
  type        = bool
  default     = true
  description = "Toggles deployment of Azure Firewall. True to deploy, otherwise false if you don't want to change the existing firewall policies. (e.g true)"
}

variable "use_premium_firewall" {
  type        = bool
  default     = true
  description = "Toggles deployment of the Premium SKU for Azure Firewall and only used if enable_Firewall is enabled. True to use Premium SKU, otherwise false. (e.g true)"
}

variable "az_firewall_policies_enabled" {
  type        = bool
  default     = true
  description = "Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies. (e.g true)"
}

variable "hub_network_address_prefix" {
  type        = string
  default     = "10.20.0.0/16"
  description = "CIDR range for the hub VNET. (e.g '10.20.0.0/16')"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.hub_network_address_prefix))
    error_message = "The hub_network_address_prefix must be a valid CIDR range, such as '10.20.0.0/16'."
  }
}

variable "custom_subnets" {
  type = map(object({
    name                   = string
    address_prefixes       = string
    networkSecurityGroupId = optional(string, "")
    routeTableId           = optional(string, "")
  }))
  default = {
    AzureBastionSubnet = {
      name                   = "AzureBastionSubnet"
      address_prefixes       = "10.20.15.0/24"
      networkSecurityGroupId = ""
      routeTableId           = ""
    }
    GatewaySubnet = {
      name                   = "GatewaySubnet"
      address_prefixes       = "10.20.252.0/24"
      networkSecurityGroupId = ""
      routeTableId           = ""
    }
    AzureFirewallSubnet = {
      name                   = "AzureFirewallSubnet"
      address_prefixes       = "10.20.254.0/24"
      networkSecurityGroupId = ""
      routeTableId           = ""
    }
  }
  description = "List of other subnets to deploy on the hub VNET and their CIDR ranges."
  validation {
    condition = alltrue([
      (contains(keys(var.custom_subnets), "AzureBastionSubnet") && var.deploy_bastion || !var.deploy_bastion),
      contains(keys(var.custom_subnets), "GatewaySubnet"),
      contains(keys(var.custom_subnets), "AzureFirewallSubnet"),
      alltrue([
        for subnet in var.custom_subnets : (
          can(subnet.name) &&
          can(subnet.address_prefixes) &&
          can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", subnet.address_prefixes))
        )
      ])
    ])
    error_message = "Must contain subnet objects for AzureBastionSubnet, GatewaySubnet and AzureFirewallSubnet. Each subnet object must contain 'name' and 'address_prefixes'."
  }
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  default     = 365
  description = "Length of time, in days, to retain log files with usage enforced by ALZ policies."
  validation {
    condition     = var.log_analytics_workspace_retention_in_days >= 30 && var.log_analytics_workspace_retention_in_days <= 730
    error_message = "The retention period must be between 30 and 730 days."
  }
}

variable "subscription_id_connectivity" {
  type        = string
  default     = ""
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
  validation {
    condition     = length(var.subscription_id_connectivity) == 0 || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id_connectivity))
    error_message = "The subscription ID must be a valid GUID in the format '00000000-0000-0000-0000-000000000000'."
  }
}

variable "subscription_id_identity" {
  type        = string
  default     = ""
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
  validation {
    condition     = length(var.subscription_id_identity) == 0 || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id_identity))
    error_message = "The subscription ID must be a valid GUID in the format '00000000-0000-0000-0000-000000000000'."
  }
}

variable "subscription_id_management" {
  type        = string
  default     = ""
  description = "The identifier of the Management Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
  validation {
    condition     = length(var.subscription_id_management) == 0 || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id_management))
    error_message = "The subscription ID must be a valid GUID in the format '00000000-0000-0000-0000-000000000000'."
  }
}

variable "policy_exemptions" {
  type = map(object({
    name                            = string
    display_name                    = string
    description                     = string
    management_group_id             = string
    policy_assignment_id            = string
    policy_definition_reference_ids = optional(list(string))
    exemption_category              = optional(string, "Mitigated")
  }))
  default     = {}
  description = "(Optional) list of policy exemptions."
}

variable "express_route_gateway_config" {
  type = object({
    name                            = optional(string)
    gatewayType                     = optional(string)
    sku                             = optional(string)
    vpnType                         = optional(string)
    vpnGatewayGeneration            = optional(string)
    enableBgp                       = optional(bool)
    activeActive                    = optional(bool)
    enableBgpRouteTranslationForNat = optional(bool)
    enableDnsForwarding             = optional(bool)
    asn                             = optional(number)
    bgpPeeringAddress               = optional(string)
    peerWeight                      = optional(number)
    vpnClientConfiguration = optional(object({
      vpnAddressSpace = optional(list(string))
    }), {})
  })
  default     = { "name" : "noconfigEr" }
  description = "(Optional) configuration options for the ExpressRoute Gateway."
}

variable "vpn_gateway_config" {
  type = object({
    name                            = optional(string)
    sku                             = optional(string)
    gatewayType                     = optional(string)
    vpnType                         = optional(string)
    vpnGatewayGeneration            = optional(string)
    enableBgp                       = optional(bool)
    activeActive                    = optional(bool)
    enableBgpRouteTranslationForNat = optional(bool)
    enableDnsForwarding             = optional(bool)
    asn                             = optional(number)
    bgpPeeringAddress               = optional(string)
    peerWeight                      = optional(number)
    vpnClientConfiguration = optional(object({
      vpnAddressSpace = optional(list(string))
    }), {})
  })
  default     = { "name" : "noconfigVpn" }
  description = "(Optional) configuration options for the VPN Gateway."
}

variable "deploy_bastion" {
  type        = bool
  default     = true
  description = "Toggles deployment of Azure Bastion. True to deploy, otherwise false. (e.g true)"
}

variable "landing_zone_management_group_children" {
  type = map(object({
    id          = string
    displayName = string
  }))
  default     = {}
  description = "(Optional) array of child management groups to deploy under the SLZ Landing Zones management group."
}

variable "architecture_definition_template_path" {
  type        = string
  default     = ""
  description = "The path to the architecture definition template file to use."
}

variable "architecture_definition_override_path" {
  type        = string
  default     = ""
  description = "The path to the architecture definition file to use instead of the default."
}

variable "apply_alz_archetypes_via_architecture_definition_template" {
  type        = bool
  default     = true
  description = "Toggles assignment of ALZ policies. True to deploy, otherwise false. (e.g true)"
}

variable "ms_defender_for_cloud_email_security_contact" {
  type        = string
  default     = "security_contact@replaceme.com"
  description = "An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to."
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.ms_defender_for_cloud_email_security_contact))
    error_message = "The email address must be a valid format."
  }
}

variable "bastion_outbound_ssh_rdp_ports" {
  type        = set(string)
  default     = ["22", "3389"]
  description = "Array of outbound destination ports and ranges for Azure Bastion."
}

variable "policy_effect" {
  type        = string
  default     = "Deny"
  description = "The policy effect used in all assignments for the Sovereignty Baseline policy initiatives."
  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.policy_effect)
    error_message = "Allowed values are 'Audit', 'Deny', and 'Disabled'."
  }
}

variable "policy_assignment_enforcement_mode" {
  type        = string
  default     = "Default"
  description = "The enforcement mode used in all policy and initiative assignments."
  validation {
    condition     = contains(["Default", "DoNotEnforce"], var.policy_assignment_enforcement_mode)
    error_message = "Allowed values are 'Default' and 'DoNotEnforce'."
  }
}

variable "deploy_log_analytics_workspace" {
  type        = bool
  default     = true
  description = "True to deploy LogAnalyticsWorkspace, otherwise false. (e.g true)"
}

variable "customer_policy_sets" {
  type = map(object({
    policySetDefinitionId                   = string
    policySetAssignmentName                 = string
    policySetAssignmentDisplayName          = string
    policySetAssignmentDescription          = string
    policySetManagementGroupAssignmentScope = string
    policyParameterFilePath                 = optional(string, "")
  }))
  default     = {}
  description = "(Optional) array of customer specified policy assignments to the mentioned scope with the optional input parameter file. If scope is empty assigned at root."
}
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags that will be assigned to subscription and resources created by this deployment script."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}