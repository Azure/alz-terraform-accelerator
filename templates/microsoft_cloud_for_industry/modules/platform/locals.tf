// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for platform
AUTHOR/S: Cloud for Industry
*/
locals {
  automation_account_name           = "${var.default_prefix}-automation-account-${var.location}${var.optional_postfix}"
  log_analytics_workspace_name      = "${var.default_prefix}-log-analytics-${var.location}${var.optional_postfix}"
  log_analytics_resource_group_name = "${var.default_prefix}-rg-logging-${var.location}${var.optional_postfix}"
  hub_rg_name                       = "${var.default_prefix}-rg-hub-network-${var.location}${var.optional_postfix}"
  firewall_policy_name              = "${var.default_prefix}-azfwpolicy-${var.location}"
  hub_vnet_name                     = "${var.default_prefix}-hub-${var.location}${var.optional_postfix}"
  route_table_name                  = "${var.default_prefix}-rt-${var.location}${var.optional_postfix}"
  nsg_name                          = "${var.default_prefix}-nsg-AzureBastionSubnet-${var.location}${var.optional_postfix}"
  gateway_public_ip_name            = "${var.default_prefix}-%s-PublicIP${var.optional_postfix}"
  ddos_plan_name                    = "${var.default_prefix}-ddos-plan${var.optional_postfix}"
  azure_bastion_public_ip_name      = "${var.default_prefix}-bas-${var.location}${var.optional_postfix}-PublicIP${var.optional_postfix}"
  azure_bastion_name                = "${var.default_prefix}-bas-${var.location}${var.optional_postfix}"
  hub_vnet_resource_id              = "/subscriptions/${var.subscription_id_connectivity}/resourceGroups/${local.hub_rg_name}/providers/Microsoft.Network/virtualNetworks/${local.hub_vnet_name}"
  subnet_id_format                  = "${local.hub_vnet_resource_id}/subnets/%s"
  firewall_policy_id                = var.az_firewall_policies_enabled ? "/subscriptions/${var.subscription_id_connectivity}/resourceGroups/${local.hub_rg_name}/providers/Microsoft.Network/firewallPolicies/${local.firewall_policy_name}" : null

  ddos_protection_plan_id    = var.deploy_hub_network && var.deploy_ddos_protection ? module.ddos_protection_plan[0].resource.id : null
  log_analytics_workspace_id = var.deploy_log_analytics_workspace ? module.alz_management[0].log_analytics_workspace.id : null

  public_ip_allocation_method = "Static"
  public_ip_sku               = "Standard"

  hubnetworks_subnets = { for k, v in var.custom_subnets :
    k => {
      address_prefixes       = [v.address_prefixes]
      name                   = v.name
      networkSecurityGroupId = v.networkSecurityGroupId
      routeTableId           = v.routeTableId
    } if v.name != "AzureFirewallSubnet"
  }

  gateway_config     = [var.vpn_gateway_config, var.express_route_gateway_config]
  gateway_config_map = { for i, gateway in local.gateway_config : i => gateway if(gateway.name != "noconfigVpn" && gateway.name != "noconfigEr") }

  nsg_rules = {
    "security_rule_01" = {
      name                       = "AllowHttpsInbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    "security_rule_02" = {
      name                       = "AllowGatewayManagerInbound"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
    "security_rule_03" = {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    "security_rule_04" = {
      name                       = "AllowBastionHostCommunication"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "security_rule_05" = {
      name                       = "DenyAllInbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    "security_rule_06" = {
      name                       = "AllowSshRdpOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = var.bastion_outbound_ssh_rdp_ports
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
    "security_rule__07" = {
      name                       = "AllowAzureCloudOutbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }
    "security_rule__08" = {
      name                       = "AllowBastionCommunication"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "security_rule_09" = {
      name                       = "AllowGetSessionInformation"
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
    "security_rule_10" = {
      name                       = "DenyAllOutbound"
      priority                   = 4096
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
