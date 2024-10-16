locals {
  subscription_id_management   = var.subscription_id_management != "" ? var.subscription_id_management : module.subscription_management_creation[0].subscription_id
  subscription_id_connectivity = var.subscription_id_connectivity != "" ? var.subscription_id_connectivity : module.subscription_connectivity_creation[0].subscription_id
  subscription_id_identity     = var.subscription_id_identity != "" ? var.subscription_id_identity : module.subscription_identity_creation[0].subscription_id
}

locals {
  # Management group timeouts
  slz_management_group_timeouts = {
    role_definition = {
      create = "60m"
    }
  }

  # Management group retriable errors configuration
  slz_management_group_retries = {
    role_definitions = {
      error_message_regex  = ["The specified role definition with ID '.+' does not exist."]
      interval             = 5
      max_interval_seconds = 30
    }
  }
}

locals {
  tenant_id                           = data.azurerm_client_config.current.tenant_id
  root_parent_management_group_id     = var.root_parent_management_group_id == "" ? local.tenant_id : var.root_parent_management_group_id
  management_group_resource_id_format = "/providers/Microsoft.Management/managementGroups/%s"
  landingzones_management_group_id    = module.slz_management_groups.management_group_resource_ids["${var.default_prefix}-landingzones${var.default_postfix}"]

  management_management_group_id       = "${var.default_prefix}-platform-management${var.default_postfix}"
  management_subscription_display_name = "${var.default_prefix}-management${var.default_postfix}"

  connectivity_management_group_id       = "${var.default_prefix}-platform-connectivity${var.default_postfix}"
  connectivity_subscription_display_name = "${var.default_prefix}-connectivity${var.default_postfix}"

  identity_management_group_id       = "${var.default_prefix}-platform-identity${var.default_postfix}"
  identity_subscription_display_name = "${var.default_prefix}-identity${var.default_postfix}"

  confidential_corp_management_group_id   = format(local.management_group_resource_id_format, "${var.default_prefix}-landingzones-confidential-corp${var.default_postfix}")
  confidential_online_management_group_id = format(local.management_group_resource_id_format, "${var.default_prefix}-landingzones-confidential-online${var.default_postfix}")

  architecture_name                 = "slz"
  azure_bastion_public_ip_name      = "${var.default_prefix}-bas-${var.default_location}${var.default_postfix}-PublicIP${var.default_postfix}"
  azure_bastion_name                = "${var.default_prefix}-bas-${var.default_location}${var.default_postfix}"
  automation_account_name           = "${var.default_prefix}-automation-account-${var.default_location}${var.default_postfix}"
  ddos_plan_name                    = "${var.default_prefix}-ddos-plan${var.default_postfix}"
  firewall_policy_name              = "${var.default_prefix}-azfwpolicy-${var.default_location}"
  firewall_policy_id                = var.az_firewall_policies_enabled ? "/subscriptions/${local.subscription_id_connectivity}/resourceGroups/${local.hub_rg_name}/providers/Microsoft.Network/firewallPolicies/${local.firewall_policy_name}" : null
  firewall_sku_name                 = "AZFW_VNet"
  gateway_public_ip_name            = "${var.default_prefix}-%s-PublicIP${var.default_postfix}"
  hub_rg_name                       = "${var.default_prefix}-rg-hub-network-${var.default_location}${var.default_postfix}"
  hub_vnet_name                     = "${var.default_prefix}-hub-${var.default_location}${var.default_postfix}"
  hub_vnet_resource_id              = "/subscriptions/${local.subscription_id_connectivity}/resourceGroups/${local.hub_rg_name}/providers/Microsoft.Network/virtualNetworks/${local.hub_vnet_name}"
  log_analytics_workspace_name      = "${var.default_prefix}-log-analytics-${var.default_location}${var.default_postfix}"
  log_analytics_resource_group_name = "${var.default_prefix}-rg-logging-${var.default_location}${var.default_postfix}"
  nsg_name                          = "${var.default_prefix}-nsg-AzureBastionSubnet-${var.default_location}${var.default_postfix}"
  route_table_name                  = "${var.default_prefix}-rt-${var.default_location}${var.default_postfix}"

  # Telemetry partner ID <PARTNER_ID_UUID>:<PARTNER_DATA_UUID>
  partner_id_uuid             = "2c12b9d4-df50-4186-bd31-ae6686b633d2" # static uuid generated for SLZ
  partner_id                  = format("%s:%s", local.partner_id_uuid, random_uuid.partner_data_uuid.result)
  public_ip_allocation_method = "Static"
  public_ip_sku               = "Standard"
  routing_address_space       = ["0.0.0.0/0"]
  subnet_id_format            = "${local.hub_vnet_resource_id}/subnets/%s"

}

locals {
  allowed_locations_list = [
    "australiacentral",
    "australiacentral2",
    "australiaeast",
    "australiasoutheast",
    "brazilsouth",
    "brazilsoutheast",
    "brazilus",
    "canadacentral",
    "canadaeast",
    "centralindia",
    "centralus",
    "centraluseuap",
    "eastasia",
    "eastus",
    "eastus2",
    "eastus2euap",
    "eastusstg",
    "francecentral",
    "francesouth",
    "germanynorth",
    "germanywestcentral",
    "israelcentral",
    "italynorth",
    "japaneast",
    "japanwest",
    "jioindiacentral",
    "jioindiawest",
    "koreacentral",
    "koreasouth",
    "northcentralus",
    "northeurope",
    "norwayeast",
    "norwaywest",
    "polandcentral",
    "qatarcentral",
    "southafricanorth",
    "southafricawest",
    "southcentralus",
    "southcentralusstg",
    "southeastasia",
    "southindia",
    "swedencentral",
    "switzerlandnorth",
    "switzerlandwest",
    "uaecentral",
    "uaenorth",
    "uksouth",
    "ukwest",
    "westcentralus",
    "westeurope",
    "westindia",
    "westus",
    "westus2",
    "westus3"
  ]

  allowed_locations_for_confidential_computing_list = [
    "australiacentral",
    "australiacentral2",
    "australiaeast",
    "australiasoutheast",
    "brazilsouth",
    "brazilsoutheast",
    "brazilus",
    "canadacentral",
    "canadaeast",
    "centralindia",
    "centralus",
    "centraluseuap",
    "eastasia",
    "eastus",
    "eastus2",
    "eastus2euap",
    "eastusstg",
    "francecentral",
    "francesouth",
    "germanynorth",
    "germanywestcentral",
    "israelcentral",
    "italynorth",
    "japaneast",
    "japanwest",
    "jioindiacentral",
    "jioindiawest",
    "koreacentral",
    "koreasouth",
    "northcentralus",
    "northeurope",
    "norwayeast",
    "norwaywest",
    "polandcentral",
    "qatarcentral",
    "southafricanorth",
    "southafricawest",
    "southcentralus",
    "southcentralusstg",
    "southeastasia",
    "southindia",
    "swedencentral",
    "switzerlandnorth",
    "switzerlandwest",
    "uaecentral",
    "uaenorth",
    "uksouth",
    "ukwest",
    "westcentralus",
    "westeurope",
    "westindia",
    "westus",
    "westus2",
    "westus3"
  ]
}

locals {
  ddos_protection_plan_id = var.deploy_ddos_protection ? module.ddos_protection_plan[0].resource.id : null
  hubnetworks_subnets = { for k, v in var.custom_subnets :
    k => {
      address_prefixes       = [v.address_prefixes]
      name                   = v.name
      networkSecurityGroupId = v.networkSecurityGroupId
      routeTableId           = v.routeTableId
    } if(k != "AzureFirewallSubnet" && var.enable_firewall) || (var.enable_firewall == false)
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

locals {
  customer_policy_sets = { for k, v in var.customer_policy_sets : k => {
    policySetDefinitionId                   = v.policySetDefinitionId
    policySetAssignmentName                 = v.policySetAssignmentName
    policySetAssignmentDisplayName          = v.policySetAssignmentDisplayName
    policySetAssignmentDescription          = v.policySetAssignmentDescription
    policySetManagementGroupAssignmentScope = v.policySetManagementGroupAssignmentScope
    policyAssignmentParameters              = v.policyParameterFilePath == "" ? "" : file(v.policyParameterFilePath)
    }
  }
}

locals {
  default_policy_exemptions = {
    "Confidential-Online-Location-Exemption" = {
      name                            = "Confidential-Online-Location-Exemption"
      display_name                    = "Confidential-Online-Location-Exemption"
      description                     = "Exempt the confidential online management group from the SLZ Global location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_online_management_group_id
      policy_assignment_id            = "${local.confidential_online_management_group_id}/providers/microsoft.authorization/policyassignments/enforce-sovereign-conf"
      policy_definition_reference_ids = ["AllowedLocationsForResourceGroups", "AllowedLocations"]
      exemption_category              = "Waiver"
    }
    "Confidential-Corp-Location-Exemption" = {
      name                            = "Confidential-Corp-Location-Exemption"
      display_name                    = "Confidential-Corp-Location-Exemption"
      description                     = "Exempt the confidential corp management group from the SLZ Global Policies location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included."
      management_group_id             = local.confidential_corp_management_group_id
      policy_assignment_id            = "${local.confidential_corp_management_group_id}/providers/microsoft.authorization/policyassignments/enforce-sovereign-conf"
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

  policy_exemptions              = merge(local.default_policy_exemptions, local.custom_policy_exemptions)
  policy_assignment_resource_ids = module.slz_management_groups.policy_assignment_resource_ids
  policy_set_definition_name     = ["deploy-diag-logs", "deploy-mdfc-config-h224"]

  slz_default_policy_values = {
    policyEffect                             = jsonencode({ value = var.policy_effect })
    listOfAllowedLocations                   = jsonencode({ value = var.allowed_locations })
    allowedLocationsForConfidentialComputing = jsonencode({ value = var.allowed_locations_for_confidential_computing })
    ddos_protection_plan_id                  = jsonencode({ value = "" })
    ddos_protection_plan_effect              = jsonencode({ value = var.deploy_ddos_protection ? "Audit" : "Disabled" })
    emailSecurityContact                     = jsonencode({ value = var.ms_defender_for_cloud_email_security_contact })
  }
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
  az_portal_link        = "https://portal.azure.com"
  management_group_link = "${local.az_portal_link}/#view/Microsoft_Azure_Resources/ManagmentGroupDrilldownMenuBlade/~/overview/tenantId/${local.tenant_id}/mgId/${var.default_prefix}${var.default_postfix}/mgDisplayName/Sovereign%20Landing%20Zone/mgCanAddOrMoveSubscription~/true/mgParentAccessLevel/Owner/defaultMenuItemId/overview/drillDownMode~/true"
  management_group_info = "If you want to learn more about your management group, please click the following link.\n\n${local.management_group_link}\n\n"

  dashboard_resource_group_name   = "${var.default_prefix}-rg-dashboards-${var.default_location}${var.default_postfix}"
  dashboard_name                  = "${var.default_prefix}-Sovereign-Landing-Zone-Dashboard-${var.default_location}${var.default_postfix}"
  dashboard_template_file_path    = "${path.root}/templates/default_dashboard.tpl"
  template_file_variables         = { root_prefix = var.default_prefix, root_postfix = var.default_postfix, customer = var.customer }
  default_template_file_variables = { name = local.dashboard_name }
  all_template_file_variables     = merge(local.default_template_file_variables, local.template_file_variables)
  domain_name                     = data.azuread_domains.default.domains[0].domain_name
  dashboard_link                  = "${local.az_portal_link}/#@${local.domain_name}/dashboard/arm/subscriptions/${var.subscription_id_management}/resourceGroups/${local.dashboard_resource_group_name}/providers/Microsoft.Portal/dashboards/${local.dashboard_name}"
  dashboard_info                  = "Now your compliance dashboard is ready for you to get insights. If you want to learn more, please click the following link.\n\n${local.dashboard_link}\n\n"
}