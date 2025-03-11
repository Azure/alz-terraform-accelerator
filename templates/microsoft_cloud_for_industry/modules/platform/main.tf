// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys platform for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.4.0"
  count   = var.deploy_log_analytics_workspace ? 1 : 0

  automation_account_name                   = local.automation_account_name
  location                                  = var.location
  log_analytics_workspace_name              = local.log_analytics_workspace_name
  resource_group_name                       = local.log_analytics_resource_group_name
  enable_telemetry                          = var.enable_telemetry
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  log_analytics_solution_plans              = var.log_analytics_solution_plans
  tags                                      = var.tags

  providers = {
    azurerm = azurerm.management
  }
}

module "hub_rg" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  location         = var.location
  name             = local.hub_rg_name
  enable_telemetry = var.enable_telemetry
  tags             = var.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "firewall_policy" {
  count   = var.deploy_hub_network && var.az_firewall_policies_enabled && var.enable_firewall ? 1 : 0
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.2.3"

  name                = local.firewall_policy_name
  location            = var.location
  resource_group_name = local.hub_rg_name
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags

  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hub_rg]
}

module "hubnetworks" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.2.0"
  count   = var.deploy_hub_network ? 1 : 0

  hub_virtual_networks = {
    hub = {
      name                            = local.hub_vnet_name
      address_space                   = [var.hub_network_address_prefix]
      location                        = var.location
      resource_group_name             = local.hub_rg_name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      resource_group_tags             = var.tags
      mesh_peering_enabled            = true
      route_table_name                = local.route_table_name
      routing_address_space           = ["0.0.0.0/0"]
      ddos_protection_plan_id         = local.ddos_protection_plan_id
      firewall = var.enable_firewall ? {
        sku_name              = "AZFW_VNet"
        sku_tier              = var.use_premium_firewall ? "Premium" : "Standard"
        subnet_address_prefix = var.custom_subnets["AzureFirewallSubnet"].address_prefixes
        firewall_policy_id    = local.firewall_policy_id
      } : null

      tags = var.tags
    }
  }

  enable_telemetry = var.enable_telemetry

  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [
    module.hub_rg,
    module.firewall_policy
  ]
}

resource "azurerm_subnet" "custom_subnets" {
  for_each = var.deploy_hub_network ? local.hubnetworks_subnets : {}

  name                 = each.value.name
  virtual_network_name = local.hub_vnet_name
  resource_group_name  = local.hub_rg_name
  address_prefixes     = each.value.address_prefixes
  provider             = azurerm.connectivity
  depends_on           = [module.hubnetworks]
}

resource "azurerm_subnet_network_security_group_association" "subnets_to_network_security_group" {
  for_each = var.deploy_hub_network ? { for k, v in var.custom_subnets : k => v if v.networkSecurityGroupId != "" } : {}

  subnet_id                 = format(local.subnet_id_format, each.value.name)
  network_security_group_id = each.value.networkSecurityGroupId

  provider   = azurerm.connectivity
  depends_on = [module.hubnetworks, azurerm_subnet.custom_subnets]
}

resource "azurerm_subnet_route_table_association" "subnets_to_route_table" {
  for_each = var.deploy_hub_network ? { for k, v in var.custom_subnets : k => v if v.routeTableId != "" } : {}

  subnet_id      = format(local.subnet_id_format, each.value.name)
  route_table_id = each.value.routeTableId

  provider   = azurerm.connectivity
  depends_on = [module.hubnetworks, azurerm_subnet.custom_subnets]
}

module "gateway_public_ip" {
  for_each = var.deploy_hub_network ? local.gateway_config_map : {}
  source   = "Azure/avm-res-network-publicipaddress/azurerm"
  version  = "0.1.2"

  allocation_method   = local.public_ip_allocation_method
  location            = var.location
  name                = format(local.gateway_public_ip_name, each.value.name)
  resource_group_name = local.hub_rg_name
  sku                 = local.public_ip_sku
  zones               = lower(each.value.gatewayType) == "vpn" ? [] : [1, 2, 3]
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hub_rg]
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  for_each = var.deploy_hub_network ? local.gateway_config_map : {}

  resource_group_name    = local.hub_rg_name
  name                   = each.value.name
  location               = var.location
  tags                   = var.tags
  active_active          = each.value.activeActive
  enable_bgp             = each.value.enableBgp
  type                   = each.value.gatewayType
  vpn_type               = each.value.vpnType
  dns_forwarding_enabled = each.value.enableDnsForwarding
  generation             = lower(each.value.gatewayType) == "vpn" ? each.value.vpnGatewayGeneration : "None"
  sku                    = each.value.sku

  dynamic "vpn_client_configuration" {
    for_each = lower(each.value.gatewayType) == "vpn" ? [each.value.vpnClientConfiguration] : []
    content {
      address_space         = lookup(vpn_client_configuration.value, "vpnAddressSpace", null)
      vpn_client_protocols  = lookup(vpn_client_configuration.value, "vpnClientProtocols", null)
      vpn_auth_types        = lookup(vpn_client_configuration.value, "vpnAuthenticationTypes", null)
      aad_tenant            = lookup(vpn_client_configuration.value, "aadTenant", null)
      aad_audience          = lookup(vpn_client_configuration.value, "aadAudience", null)
      aad_issuer            = lookup(vpn_client_configuration.value, "aadIssuer", null)
      radius_server_address = lookup(vpn_client_configuration.value, "radiusServerAddress", null)
      radius_server_secret  = lookup(vpn_client_configuration.value, "radiusServerSecret", null)
    }
  }

  ip_configuration {
    name                 = "vnetGatewayConfig"
    subnet_id            = format(local.subnet_id_format, "GatewaySubnet")
    public_ip_address_id = module.gateway_public_ip[each.key].public_ip_id
  }

  provider   = azurerm.connectivity
  depends_on = [module.hubnetworks, module.gateway_public_ip, azurerm_subnet.custom_subnets]
}

module "private_dns_zones" {
  count   = var.deploy_hub_network ? 1 : 0
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.5.0"

  location                        = var.location
  resource_group_name             = local.hub_rg_name
  resource_group_creation_enabled = false
  virtual_network_resource_ids_to_link_to = {
    "vnet" = {
      vnet_resource_id = local.hub_vnet_resource_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hubnetworks]
}

module "ddos_protection_plan" {
  count   = var.deploy_hub_network && var.deploy_ddos_protection ? 1 : 0
  source  = "Azure/avm-res-network-ddosprotectionplan/azurerm"
  version = "0.2.0"

  resource_group_name = local.hub_rg_name
  name                = lower(local.ddos_plan_name)
  location            = var.location
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags

  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hub_rg]
}

module "nsg" {
  count   = var.deploy_hub_network && var.deploy_bastion ? 1 : 0
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "v0.2.0"

  resource_group_name = local.hub_rg_name
  name                = local.nsg_name
  location            = var.location
  security_rules      = local.nsg_rules
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hub_rg]
}

module "azure_bastion_public_ip" {
  count   = var.deploy_hub_network && var.deploy_bastion ? 1 : 0
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.2"

  allocation_method   = local.public_ip_allocation_method
  location            = var.location
  name                = local.azure_bastion_public_ip_name
  resource_group_name = local.hub_rg_name
  sku                 = local.public_ip_sku
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
  providers = {
    azurerm = azurerm.connectivity
  }
  depends_on = [module.hub_rg]
}

module "azure_bastion" {
  count   = var.deploy_hub_network && var.deploy_bastion ? 1 : 0
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"

  name                = local.azure_bastion_name
  resource_group_name = local.hub_rg_name
  location            = var.location
  copy_paste_enabled  = true
  file_copy_enabled   = false
  sku                 = "Standard"
  ip_configuration = {
    name                 = "IpConf"
    subnet_id            = format(local.subnet_id_format, "AzureBastionSubnet")
    public_ip_address_id = var.deploy_bastion ? module.azure_bastion_public_ip[0].public_ip_id : null
  }
  ip_connect_enabled     = true
  scale_units            = 4
  shareable_link_enabled = true
  tunneling_enabled      = true
  kerberos_enabled       = true
  enable_telemetry       = var.enable_telemetry
  tags                   = var.tags
  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [module.hub_rg, module.hubnetworks, module.azure_bastion_public_ip, azurerm_subnet.custom_subnets]
}

resource "azurerm_subnet_network_security_group_association" "nsg_link_bastion_subnet" {
  count                     = var.deploy_hub_network && var.deploy_bastion ? 1 : 0
  subnet_id                 = format(local.subnet_id_format, "AzureBastionSubnet")
  network_security_group_id = module.nsg[0].resource_id

  provider   = azurerm.connectivity
  depends_on = [azurerm_subnet.custom_subnets, module.nsg]
}
