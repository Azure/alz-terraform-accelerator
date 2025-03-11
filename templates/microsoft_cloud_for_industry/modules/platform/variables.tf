// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for creating platform
AUTHOR/S: Cloud for Industry
*/
variable "location" {
  type        = string
  description = "Location used for deploying Azure resources. (e.g 'uksouth')|azure_location"
}

variable "default_prefix" {
  type        = string
  description = "Prefix added to all Azure resources created by the Landing Zone. (e.g 'mcfs' or 'fsi')"
  validation {
    condition     = length(var.default_prefix) >= 2 && length(var.default_prefix) <= 5
    error_message = "The prefix must be between 2 and 5 characters long."
  }
}

variable "optional_postfix" {
  type        = string
  default     = ""
  description = "The deployment postfix for Azure resources. (e.g 'dev')"
  validation {
    condition     = length(var.optional_postfix) >= 0 && length(var.optional_postfix) <= 5
    error_message = "The prefix must be between 0 and 5 characters long."
  }
}

variable "deploy_log_analytics_workspace" {
  type        = bool
  default     = true
  description = "True to deploy LogAnalyticsWorkspace, otherwise false. (e.g true)"
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

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  default     = 365
  description = "Length of time, in days, to retain log files with usage enforced by ALZ policies."
  validation {
    condition     = var.log_analytics_workspace_retention_in_days >= 30 && var.log_analytics_workspace_retention_in_days <= 730
    error_message = "The retention period must be between 30 and 730 days."
  }
}

variable "log_analytics_solution_plans" {
  type = list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
  default = [
    {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/VMInsights"
      publisher = "Microsoft"
    },
  ]
  description = "The Log Analytics Solution Plans to create. Do not add the SecurityInsights solution plan here, this deployment method is deprecated. Instead refer to"
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags that will be assigned to subscription and resources created by this deployment script."
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

variable "deploy_ddos_protection" {
  type        = bool
  default     = true
  description = "Toggles deployment of Azure DDOS protection. True to deploy, otherwise false. (e.g true)"
}

variable "use_premium_firewall" {
  type        = bool
  default     = true
  description = "Toggles deployment of the Premium SKU for Azure Firewall and only used if enable_Firewall is enabled. True to use Premium SKU, otherwise false. (e.g true)"
}

variable "hub_network_address_prefix" {
  type        = string
  default     = "10.20.0.0/16"
  description = "CIDR range for the hub VNET. (e.g '10.20.0.0/16')|14|"
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

variable "az_firewall_policies_enabled" {
  type        = bool
  default     = true
  description = "Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies. (e.g true)"
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

variable "deploy_bastion" {
  type        = bool
  default     = true
  description = "Toggles deployment of Azure Bastion. True to deploy, otherwise false. (e.g true)"
}

variable "subscription_id_connectivity" {
  type        = string
  default     = ""
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "vpn_gateway_config" {
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
  default     = { "name" : "noconfigVpn" }
  description = "(Optional) configuration options for the VPN Gateway."
}

variable "bastion_outbound_ssh_rdp_ports" {
  type        = set(string)
  default     = ["22", "3389"]
  description = "Array of outbound destination ports and ranges for Azure Bastion."
}
