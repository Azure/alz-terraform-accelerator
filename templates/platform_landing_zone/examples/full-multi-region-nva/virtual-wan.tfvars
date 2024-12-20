/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each built-in replacemnets that you can use:
`starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_02` to `starter_location_10`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_01_availability_zones` to `starter_location_10_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
`starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_10_virtual_network_gateway_sku_express_route`: These are the default SKUs for the Express Route virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_10_virtual_network_gateway_sku_vpn`: These are the default SKUs for the VPN virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
`subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
`subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
`subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.
*/

/*
--- Custom Replacements ---
You can define custom replacements to use throughout the configuration.
*/
custom_replacements = {
  /* 
  --- Custom Name Replacements ---
  You can define custom names and other strings to use throughout the configuration. 
  You can only use the built in replacements in this section.
  NOTE: You cannot refer to another custom name in this variable.
  */
  names = {
    # Resource group names
    management_resource_group_name                 = "rg-management-$${starter_location_01}"
    connectivity_hub_vwan_resource_group_name      = "rg-hub-vwan-$${starter_location_01}"
    connectivity_hub_primary_resource_group_name   = "rg-hub-$${starter_location_01}"
    connectivity_hub_secondary_resource_group_name = "rg-hub-$${starter_location_02}"
    dns_resource_group_name                        = "rg-hub-dns-$${starter_location_01}"
    ddos_resource_group_name                       = "rg-hub-ddos-$${starter_location_01}"
    asc_export_resource_group_name                 = "rg-asc-export-$${starter_location_01}"

    # Resource names
    log_analytics_workspace_name            = "law-management-$${starter_location_01}"
    ddos_protection_plan_name               = "ddos-$${starter_location_01}"
    automation_account_name                 = "aa-management-$${starter_location_01}"
    ama_user_assigned_managed_identity_name = "uami-management-ama-$${starter_location_01}"
    dcr_change_tracking_name                = "dcr-change-tracking"
    dcr_defender_sql_name                   = "dcr-defender-sql"
    dcr_vm_insights_name                    = "dcr-vm-insights"

     # Resource names primary connectivity
    primary_hub_name                                   = "vwan-hub-$${starter_location_01}"
    primary_sidecar_virtual_network_name               = "vnet-sidecar-$${starter_location_01}"
    primary_subnet_nva_name                            = "subnet-nva-$${starter_location_01}"
    primary_virtual_network_gateway_express_route_name = "vgw-hub-er-$${starter_location_01}"
    primary_virtual_network_gateway_vpn_name           = "vgw-hub-vpn-$${starter_location_01}"
    primary_private_dns_resolver_name                  = "pdr-hub-dns-$${starter_location_01}"
    primary_bastion_host_name                          = "btn-hub-$${starter_location_01}"
    primary_bastion_host_public_ip_name                = "pip-bastion-hub-$${starter_location_01}"

    # Resource names secondary connectivity
    secondary_hub_name                                   = "vwan-hub-$${starter_location_02}"
    secondary_sidecar_virtual_network_name               = "vnet-sidecar-$${starter_location_02}"
    secondary_subnet_nva_name                            = "subnet-nva-$${starter_location_02}"
    secondary_virtual_network_gateway_express_route_name = "vgw-hub-er-$${starter_location_02}"
    secondary_virtual_network_gateway_vpn_name           = "vgw-hub-vpn-$${starter_location_02}"
    secondary_private_dns_resolver_name                  = "pdr-hub-dns-$${starter_location_02}"
    secondary_bastion_host_name                          = "btn-hub-$${starter_location_02}"
    secondary_bastion_host_public_ip_name                = "pip-bastion-hub-$${starter_location_02}"

    # Private DNS Zones primary
    primary_auto_registration_zone_name = "$${starter_location_01}.azure.local"

    # Private DNS Zones secondary
    secondary_auto_registration_zone_name = "$${starter_location_02}.azure.local"

    # IP Ranges Primary
    # Regional Address Space: 10.0.0.0/16
    primary_hub_address_space                          = "10.0.0.0/22"
    primary_side_car_virtual_network_address_space     = "10.0.4.0/22"
    primary_bastion_subnet_address_prefix              = "10.0.4.0/26"
    primary_nva_subnet_address_prefix                  = "10.0.4.64/26"
    primary_nva_ip_address                             = "10.0.4.68"
    primary_private_dns_resolver_subnet_address_prefix = "10.0.4.128/28"


    # IP Ranges Secondary
    # Regional Address Space: 10.1.0.0/16
    secondary_hub_address_space                          = "10.1.0.0/22"
    secondary_side_car_virtual_network_address_space     = "10.1.4.0/22"
    secondary_bastion_subnet_address_prefix              = "10.1.4.0/26"
    secondary_nva_subnet_address_prefix                  = "10.1.4.64/26"
    secondary_nva_ip_address                             = "10.1.4.68"
    secondary_private_dns_resolver_subnet_address_prefix = "10.1.4.128/28"
  }

  /* 
  --- Custom Resource Group Identifier Replacements ---
  You can define custom resource group identifiers to use throughout the configuration. 
  You can only use the templated variables and custom names in this section.
  NOTE: You cannot refer to another custom resource group identifier in this variable.
  */
  resource_group_identifiers = {
    management_resource_group_id           = "/subscriptions/$${subscription_id_management}/resourcegroups/$${management_resource_group_name}"
    ddos_protection_plan_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourcegroups/$${ddos_resource_group_name}"
  }

  /* 
  --- Custom Resource Identifier Replacements ---
  You can define custom resource identifiers to use throughout the configuration. 
  You can only use the templated variables, custom names and customer resource group identifiers in this variable.
  NOTE: You cannot refer to another custom resource identifier in this variable.
  */
  resource_identifiers = {
    ama_change_tracking_data_collection_rule_id = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_change_tracking_name}"
    ama_mdfc_sql_data_collection_rule_id        = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_defender_sql_name}"
    ama_vm_insights_data_collection_rule_id     = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_vm_insights_name}"
    ama_user_assigned_managed_identity_id       = "$${management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/$${log_analytics_workspace_name}"
    ddos_protection_plan_id                     = "$${ddos_protection_plan_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
  }
}

enable_telemetry = false

/*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
tags = {
  deployed_by = "terraform"
  source      = "Azure Landing Zones Accelerator"
}

/* 
--- Management Resources ---
You can use this section to customize the management resources that will be deployed.
*/
management_resource_settings = {
  automation_account_name      = "$${automation_account_name}"
  location                     = "$${starter_location_01}"
  log_analytics_workspace_name = "$${log_analytics_workspace_name}"
  resource_group_name          = "$${management_resource_group_name}"
  user_assigned_managed_identities = {
    ama = {
      name = "$${ama_user_assigned_managed_identity_name}"
    }
  }
  data_collection_rules = {
    change_tracking = {
      name = "$${dcr_change_tracking_name}"
    }
    defender_sql = {
      name = "$${dcr_defender_sql_name}"
    }
    vm_insights = {
      name = "$${dcr_vm_insights_name}"
    }
  }
}

/* 
--- Management Groups and Policy ---
You can use this section to customize the management groups and policies that will be deployed.
You can further configure management groups and policy by supplying a `lib` folder. This is detailed in the Accelerator documentation.
*/
management_group_settings = {
  location           = "$${starter_location_01}"
  architecture_name  = "alz"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = "$${ama_change_tracking_data_collection_rule_id}"
    ama_mdfc_sql_data_collection_rule_id        = "$${ama_mdfc_sql_data_collection_rule_id}"
    ama_vm_insights_data_collection_rule_id     = "$${ama_vm_insights_data_collection_rule_id}"
    ama_user_assigned_managed_identity_id       = "$${ama_user_assigned_managed_identity_id}"
    ama_user_assigned_managed_identity_name     = "$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${log_analytics_workspace_id}"
    ddos_protection_plan_id                     = "$${ddos_protection_plan_id}"
    private_dns_zone_subscription_id            = "$${subscription_id_connectivity}"
    private_dns_zone_region                     = "$${starter_location_01}"
    private_dns_zone_resource_group_name        = "$${dns_resource_group_name}"
  }
  subscription_placement = {
    identity = {
      subscription_id       = "$${subscription_id_identity}"
      management_group_name = "identity"
    }
    connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "connectivity"
    }
    management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "management"
    }
  }
  policy_assignments_to_modify = {
    alzroot = {
      policy_assignments = {
        Deploy-MDFC-Config-H224 = {
          parameters = {
            ascExportResourceGroupName                  = "$${asc_export_resource_group_name}"
            ascExportResourceGroupLocation              = "$${starter_location_01}"
            emailSecurityContact                        = "security_contact@replace_me"
            enableAscForServers                         = "DeployIfNotExists"
            enableAscForServers                         = "DeployIfNotExists"
            enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
            enableAscForSql                             = "DeployIfNotExists"
            enableAscForAppServices                     = "DeployIfNotExists"
            enableAscForStorage                         = "DeployIfNotExists"
            enableAscForContainers                      = "DeployIfNotExists"
            enableAscForKeyVault                        = "DeployIfNotExists"
            enableAscForSqlOnVm                         = "DeployIfNotExists"
            enableAscForArm                             = "DeployIfNotExists"
            enableAscForOssDb                           = "DeployIfNotExists"
            enableAscForCosmosDbs                       = "DeployIfNotExists"
            enableAscForCspm                            = "DeployIfNotExists"
          }
        }
      }
    }
    /*
    # Example of how to update a policy assignment enforcement mode for DDOS Protection Plan
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    */
    /*
    # Example of how to update a policy assignment enforcement mode for Private Link DNS Zones
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    */
  }
}

/* 
--- Connectivity - Virtual WAN ---
You can use this section to customize the virtual wan networking that will be deployed.
*/
connectivity_type = "virtual_wan"

connectivity_resource_groups = {
  ddos = {
    name     = "$${ddos_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vwan = {
    name     = "$${connectivity_hub_vwan_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vwan_hub_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vwan_hub_secondary = {
    name     = "$${connectivity_hub_secondary_resource_group_name}"
    location = "$${starter_location_02}"
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
  }
}

virtual_wan_settings = {
  name                = "vwan-$${starter_location_01}"
  resource_group_name = "$${connectivity_hub_vwan_resource_group_name}"
  location            = "$${starter_location_01}"
  ddos_protection_plan = {
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}

virtual_wan_virtual_hubs = {
  primary = {
    hub = {
      name = "$${primary_hub_name}"
      /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
      */
      resource_group = "$${connectivity_hub_primary_resource_group_name}"
      location       = "$${starter_location_01}"
      address_prefix = "$${primary_hub_address_space}"
    }
    virtual_network_gateways = {
      express_route = {
        name = "$${primary_virtual_network_gateway_express_route_name}"
      }
      vpn = {
        name = "$${primary_virtual_network_gateway_vpn_name}"
      }
    }
    private_dns_zones = {
      resource_group_name            = "$${dns_resource_group_name}"
      is_primary                     = true
      auto_registration_zone_enabled = true
      auto_registration_zone_name    = "$${primary_auto_registration_zone_name}"
      subnet_address_prefix          = "$${primary_private_dns_resolver_subnet_address_prefix}"
      private_dns_resolver = {
        name = "$${primary_dns_resolver_name}"
      }
    }
    bastion = {
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      bastion_host = {
        name = "$${primary_bastion_host_name}"
      }
      bastion_public_ip = {
        name  = "$${primary_bastion_host_public_ip_name}"
        zones = "$${starter_location_01_availability_zones}"
      }
    }
    side_car_virtual_network = {
      name          = "$${primary_sidecar_virtual_network_name}"
      address_space = ["$${primary_side_car_virtual_network_address_space}"]
      subnets = {
        nva = {
          name             = "$${primary_subnet_nva_name}"
          address_prefixes = ["$${primary_nva_subnet_address_prefix}"]
        }
      }
    }
  }
  secondary = {
    hub = {
      name = "$${secondary_hub_name}"
      /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
      */
      resource_group = "$${connectivity_hub_secondary_resource_group_name}"
      location       = "$${starter_location_02}"
      address_prefix = "$${secondary_hub_address_space}"
    }
    virtual_network_gateways = {
      express_route = {
        name = "$${secondary_virtual_network_gateway_express_route_name}"
      }
      vpn = {
        name = "$${secondary_virtual_network_gateway_vpn_name}"
      }
    }
    private_dns_zones = {
      resource_group_name            = "$${dns_resource_group_name}"
      is_primary                     = false
      auto_registration_zone_enabled = true
      auto_registration_zone_name    = "$${secondary_auto_registration_zone_name}"
      subnet_address_prefix          = "$${secondary_private_dns_resolver_subnet_address_prefix}"
      private_dns_resolver = {
        name = "$${secondary_dns_resolver_name}"
      }
    }
    bastion = {
      subnet_address_prefix = "$${secondary_bastion_subnet_address_prefix}"
      bastion_host = {
        name = "$${secondary_bastion_host_name}"
      }
      bastion_public_ip = {
        name  = "$${secondary_bastion_host_public_ip_name}"
        zones = "$${starter_location_02_availability_zones}"
      }
    }
    side_car_virtual_network = {
      name          = "$${secondary_sidecar_virtual_network_name}"
      address_space = ["$${secondary_side_car_virtual_network_address_space}"]
      subnets = {
        nva = {
          name             = "$${secondary_subnet_nva_name}"
          address_prefixes = ["$${secondary_nva_subnet_address_prefix}"]
        }
      }
    }
  }
}
