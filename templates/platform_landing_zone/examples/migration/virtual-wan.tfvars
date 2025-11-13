/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each built-in replacements that you can use:
`starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_02` to `starter_location_##`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_01_short`: Short code for the primary Azure location (for example `uks` for `uksouth`). When a short code is not available for a region, this falls back to the full `starter_location_01` value.
`starter_location_02_short` to `starter_location_##_short`: Short codes for the secondary Azure locations. Each falls back to the corresponding `starter_location_##` value when a short code is not available.
`root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
`subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_ids`.
`subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_ids`.
`subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_ids`.
`subscription_id_security`: The subscription ID of the subscription to deploy the security resources to, sourced from the variable `subscription_ids`.
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
    # Defender email security contact
    defender_email_security_contact = "replace_me@replace_me.com"

    # Resource group names
    management_resource_group_name                 = "alz-mgmt"         # MIGRATION: This had a different default in CAF ES.
    connectivity_hub_vwan_resource_group_name      = "alz-connectivity" # MIGRATION: This had a different default in CAF ES.
    connectivity_hub_primary_resource_group_name   = "rg-hub-$${starter_location_01}"
    connectivity_hub_secondary_resource_group_name = "rg-hub-$${starter_location_02}"
    dns_resource_group_name                        = "alz-dns"  # MIGRATION: This had a different default in CAF ES.
    ddos_resource_group_name                       = "alz-ddos" # MIGRATION: This had a different default in CAF ES.
    asc_export_resource_group_name                 = "rg-asc-export-$${starter_location_01}"

    # Resource names
    log_analytics_workspace_name            = "alz-la"                      # MIGRATION: This had a different default in CAF ES.
    ddos_protection_plan_name               = "alz-ddos-uksouth"            # MIGRATION: This had a different default in CAF ES.
    ama_user_assigned_managed_identity_name = "alz-uami"                    # MIGRATION: This had a different default in CAF ES.
    dcr_change_tracking_name                = "alz-dcr-changetracking-prod" # MIGRATION: This had a different default in CAF ES.
    dcr_defender_sql_name                   = "alz-dcr-defendersql-prod"    # MIGRATION: This had a different default in CAF ES.
    dcr_vm_insights_name                    = "alz-dcr-vm-insights"         # MIGRATION: This had a different default in CAF ES.

    # Resource provisioning global connectivity
    ddos_protection_plan_enabled = true

    # Resource provisioning primary connectivity
    primary_firewall_enabled                              = true
    primary_virtual_network_gateway_express_route_enabled = true
    primary_virtual_network_gateway_vpn_enabled           = true
    primary_private_dns_zones_enabled                     = true
    primary_private_dns_auto_registration_zone_enabled    = true
    primary_private_dns_resolver_enabled                  = true
    primary_bastion_enabled                               = true
    primary_sidecar_virtual_network_enabled               = true

    # Resource provisioning secondary connectivity
    secondary_firewall_enabled                              = true
    secondary_virtual_network_gateway_express_route_enabled = true
    secondary_virtual_network_gateway_vpn_enabled           = true
    secondary_private_dns_zones_enabled                     = true
    secondary_private_dns_auto_registration_zone_enabled    = true
    secondary_private_dns_resolver_enabled                  = true
    secondary_bastion_enabled                               = true
    secondary_sidecar_virtual_network_enabled               = true

    # Resource names primary connectivity
    primary_hub_name                                   = "alz-hub-$${starter_location_01}" # MIGRATION: This had a different default in CAF ES.
    primary_sidecar_virtual_network_name               = "vnet-sidecar-$${starter_location_01}"
    primary_firewall_name                              = "alz-fw-hub-$${starter_location_01}"        # MIGRATION: This had a different default in CAF ES.
    primary_firewall_policy_name                       = "alz-fw-hub-$${starter_location_01}-policy" # MIGRATION: This had a different default in CAF ES.
    primary_virtual_network_gateway_express_route_name = "alz-ergw-$${starter_location_01}"          # MIGRATION: This had a different default in CAF ES.
    primary_virtual_network_gateway_vpn_name           = "alz-vpngw-$${starter_location_01}"         # MIGRATION: This had a different default in CAF ES.
    primary_private_dns_resolver_name                  = "pdr-hub-dns-$${starter_location_01}"
    primary_bastion_host_name                          = "bas-hub-$${starter_location_01}"
    primary_bastion_host_public_ip_name                = "pip-bastion-hub-$${starter_location_01}"

    # Resource names secondary connectivity
    secondary_hub_name                                   = "alz-hub-$${starter_location_02}" # MIGRATION: This had a different default in CAF ES.
    secondary_sidecar_virtual_network_name               = "vnet-sidecar-$${starter_location_02}"
    secondary_firewall_name                              = "alz-fw-hub-$${starter_location_02}"        # MIGRATION: This had a different default in CAF ES.
    secondary_firewall_policy_name                       = "alz-fw-hub-$${starter_location_02}-policy" # MIGRATION: This had a different default in CAF ES.
    secondary_virtual_network_gateway_express_route_name = "alz-ergw-$${starter_location_02}"          # MIGRATION: This had a different default in CAF ES.
    secondary_virtual_network_gateway_vpn_name           = "alz-vpngw-$${starter_location_02}"         # MIGRATION: This had a different default in CAF ES.
    secondary_private_dns_resolver_name                  = "pdr-hub-dns-$${starter_location_02}"
    secondary_bastion_host_name                          = "bas-hub-$${starter_location_02}"
    secondary_bastion_host_public_ip_name                = "pip-bastion-hub-$${starter_location_02}"

    # Private DNS Zones primary
    primary_auto_registration_zone_name = "$${starter_location_01}.azure.local"

    # Private DNS Zones secondary
    secondary_auto_registration_zone_name = "$${starter_location_02}.azure.local"

    # IP Ranges Primary
    # Regional Address Space: 10.100.0.0/16
    primary_hub_address_space                          = "10.100.0.0/22"  # MIGRATION: This had a different default in CAF ES.
    primary_sidecar_virtual_network_address_space      = "10.100.4.0/22"  # MIGRATION: This had a different default in CAF ES.
    primary_bastion_subnet_address_prefix              = "10.100.4.0/26"  # MIGRATION: This had a different default in CAF ES.
    primary_private_dns_resolver_subnet_address_prefix = "10.100.4.64/28" # MIGRATION: This had a different default in CAF ES.

    # IP Ranges Secondary
    # Regional Address Space: 10.101.0.0/16
    secondary_hub_address_space                          = "10.101.0.0/22"  # MIGRATION: This had a different default in CAF ES.
    secondary_sidecar_virtual_network_address_space      = "10.101.4.0/22"  # MIGRATION: This had a different default in CAF ES.
    secondary_bastion_subnet_address_prefix              = "10.101.4.0/26"  # MIGRATION: This had a different default in CAF ES.
    secondary_private_dns_resolver_subnet_address_prefix = "10.101.4.64/28" # MIGRATION: This had a different default in CAF ES.
  }

  /*
  --- Custom Resource Group Identifier Replacements ---
  You can define custom resource group identifiers to use throughout the configuration.
  You can only use the templated variables and custom names in this section.
  NOTE: You cannot refer to another custom resource group identifier in this variable.
  */
  resource_group_identifiers = {
    management_resource_group_id             = "/subscriptions/$${subscription_id_management}/resourcegroups/$${management_resource_group_name}"
    ddos_protection_plan_resource_group_id   = "/subscriptions/$${subscription_id_connectivity}/resourcegroups/$${ddos_resource_group_name}"
    primary_connectivity_resource_group_id   = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/$${connectivity_hub_primary_resource_group_name}"
    secondary_connectivity_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/$${connectivity_hub_secondary_resource_group_name}"
    connectivity_hub_vwan_resource_group_id  = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/$${connectivity_hub_vwan_resource_group_name}"
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

enable_telemetry = true

/*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
tags = { # MIGRATION: This had a different default in CAF ES.
  demo_type  = "Deploy connectivity resources using multiple module declarations"
  deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
}

/*
--- Management Resources ---
You can use this section to customize the management resources that will be deployed.
*/
management_resource_settings = {
  enabled                                   = true
  location                                  = "$${starter_location_01}"
  log_analytics_workspace_name              = "$${log_analytics_workspace_name}"
  log_analytics_workspace_retention_in_days = 60 # MIGRATION: This had a different default in CAF ES.
  resource_group_name                       = "$${management_resource_group_name}"
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
  tags = { # MIGRATION: This had a different default in CAF ES.
    demo_type  = "Deploy management resources using multiple module declarations"
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
  }
}

/*
--- Management Groups and Policy ---
You can use this section to customize the management groups and policies that will be deployed.
You can further configure management groups and policy by supplying a `lib` folder. This is detailed in the Accelerator documentation.
*/
management_group_settings = {
  enabled = true
  # This is the name of the architecture that will be used to deploy the management resources.
  # It refers to the alz_custom.alz_architecture_definition.yaml file in the lib folder.
  # Do not change this value unless you have created another architecture definition
  # with the name value specified below.
  architecture_name  = "alz_custom"
  location           = "$${starter_location_01}"
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
      management_group_name = "alz-identity" # MIGRATION: You may need to update this based on your management group IDs
    }
    connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "alz-connectivity" # MIGRATION: You may need to update this based on your management group IDs
    }
    management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "alz-management" # MIGRATION: You may need to update this based on your management group IDs
    }
    security = {
      subscription_id       = "$${subscription_id_security}"
      management_group_name = "security"
    }
  }
  policy_assignments_to_modify = {
    alz = { # MIGRATION: You may need to update this based on your management group IDs
      policy_assignments = {
        Deploy-MDFC-Config-H224 = {
          parameters = {
            ascExportResourceGroupName                  = "$${asc_export_resource_group_name}"
            ascExportResourceGroupLocation              = "$${starter_location_01}"
            emailSecurityContact                        = "$${defender_email_security_contact}"
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
  }
  /*
  # Example of how to add management group role assignments
  management_group_role_assignments = {
    root_owner_role_assignment = {
      management_group_name      = "root"
      role_definition_id_or_name = "Owner"
      principal_id               = "00000000-0000-0000-0000-000000000000"
    }
  }
  */
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
    settings = {
      enabled = "$${ddos_protection_plan_enabled}"
    }
  }
  vwan = {
    name     = "$${connectivity_hub_vwan_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = true
    }
  }
  vwan_hub_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = true
    }
  }
  vwan_hub_secondary = {
    name     = "$${connectivity_hub_secondary_resource_group_name}"
    location = "$${starter_location_02}"
    settings = {
      enabled = true
    }
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = "$${primary_private_dns_zones_enabled}"
    }
  }
}

virtual_wan_settings = {
  enabled_resources = {
    ddos_protection_plan = "$${ddos_protection_plan_enabled}"
  }
  virtual_wan = {
    name                = "alz-vwan-$${starter_location_01}" # MIGRATION: This had a different default in CAF ES.
    resource_group_name = "$${connectivity_hub_vwan_resource_group_name}"
    location            = "$${starter_location_01}"
  }
  ddos_protection_plan = {
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}

virtual_hubs = {
  primary = {
    location = "$${starter_location_01}"
    /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
    */
    default_parent_id = "$${primary_connectivity_resource_group_id}"
    enabled_resources = {
      firewall                              = "$${primary_firewall_enabled}"
      bastion                               = "$${primary_bastion_enabled}"
      virtual_network_gateway_express_route = "$${primary_virtual_network_gateway_express_route_enabled}"
      virtual_network_gateway_vpn           = "$${primary_virtual_network_gateway_vpn_enabled}"
      private_dns_zones                     = "$${primary_private_dns_zones_enabled}"
      private_dns_resolver                  = "$${primary_private_dns_resolver_enabled}"
      sidecar_virtual_network               = "$${primary_sidecar_virtual_network_enabled}"
    }
    hub = {
      name           = "$${primary_hub_name}"
      parent_id      = "$${connectivity_hub_vwan_resource_group_id}" # MIGRATION: The CAF ES module did not have a separate resource group for the hub by default.
      address_prefix = "$${primary_hub_address_space}"
      sku            = "Standard" # MIGRATION: The CAF ES module supplied the SKU
    }
    firewall = {
      name = "$${primary_firewall_name}"
      tags = { # MIGRATION: This had a different default in CAF ES.
        demo_type  = "Deploy connectivity resources using multiple module declarations"
        deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
      }
    }
    firewall_policy = {
      name = "$${primary_firewall_policy_name}"
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
      resource_group_name = "$${dns_resource_group_name}"
      private_link_private_dns_zones_regex_filter = {
        enabled = false
      }
      auto_registration_zone_enabled = "$${primary_private_dns_auto_registration_zone_enabled}"
      auto_registration_zone_name    = "$${primary_auto_registration_zone_name}"
    }
    private_dns_resolver = {
      subnet_address_prefix = "$${primary_private_dns_resolver_subnet_address_prefix}"
      name                  = "$${primary_private_dns_resolver_name}"
    }
    bastion = {
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      name                  = "$${primary_bastion_host_name}"
      bastion_public_ip = {
        name = "$${primary_bastion_host_public_ip_name}"
      }
    }
    sidecar_virtual_network = {
      name          = "$${primary_sidecar_virtual_network_name}"
      address_space = ["$${primary_sidecar_virtual_network_address_space}"]
      /*
      virtual_network_connection_settings = {
        name = "private_dns_vnet_primary"  # Backwards compatibility
      }
      */
    }
  }
  secondary = {
    location = "$${starter_location_02}"
    /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
    */
    default_parent_id = "$${secondary_connectivity_resource_group_id}"
    enabled_resources = {
      firewall                              = "$${secondary_firewall_enabled}"
      bastion                               = "$${secondary_bastion_enabled}"
      virtual_network_gateway_express_route = "$${secondary_virtual_network_gateway_express_route_enabled}"
      virtual_network_gateway_vpn           = "$${secondary_virtual_network_gateway_vpn_enabled}"
      private_dns_zones                     = "$${secondary_private_dns_zones_enabled}"
      private_dns_resolver                  = "$${secondary_private_dns_resolver_enabled}"
      sidecar_virtual_network               = "$${secondary_sidecar_virtual_network_enabled}"
    }
    hub = {
      name = "$${secondary_hub_name}"
      /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
      */
      parent_id      = "$${connectivity_hub_vwan_resource_group_id}" # MIGRATION: The CAF ES module did not have a separate resource group for the hub by default.
      address_prefix = "$${secondary_hub_address_space}"
      sku            = "Standard" # MIGRATION: The CAF ES module supplied the SKU
    }
    firewall = {
      name = "$${secondary_firewall_name}"
      tags = { # MIGRATION: This had a different default in CAF ES.
        demo_type  = "Deploy connectivity resources using multiple module declarations"
        deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
      }
    }
    firewall_policy = {
      name = "$${secondary_firewall_policy_name}"
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
      resource_group_name = "$${dns_resource_group_name}"
      private_link_private_dns_zones_regex_filter = {
        enabled = true
      }
      auto_registration_zone_enabled = "$${secondary_private_dns_auto_registration_zone_enabled}"
      auto_registration_zone_name    = "$${secondary_auto_registration_zone_name}"
    }
    private_dns_resolver = {
      subnet_address_prefix = "$${secondary_private_dns_resolver_subnet_address_prefix}"
      name                  = "$${secondary_private_dns_resolver_name}"
    }
    bastion = {
      subnet_address_prefix = "$${secondary_bastion_subnet_address_prefix}"
      name                  = "$${secondary_bastion_host_name}"
      bastion_public_ip = {
        name = "$${secondary_bastion_host_public_ip_name}"
      }
    }
    sidecar_virtual_network = {
      name          = "$${secondary_sidecar_virtual_network_name}"
      address_space = ["$${secondary_sidecar_virtual_network_address_space}"]
      /*
      virtual_network_connection_settings = {
        name = "private_dns_vnet_secondary"  # Backwards compatibility
      }
      */
    }
  }
}
