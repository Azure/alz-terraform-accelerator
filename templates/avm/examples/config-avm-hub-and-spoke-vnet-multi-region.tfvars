/*
This file contains templated variables to avoid repeating the same hard-coded values.
Templated variables are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each templated variable that you can use:
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
Custom Names: Based on any of the above variables, you can create your own custom names to use in the configuration by supplying them in the `custom_names` map variable.
This avoids repeating the same hard-coded values in the configuration. 
For example, you can use the custom name `$${management_resource_group_name}` in the configuration instead of hard-coding the value `rg-management-$${starter_location_01}`.
NOTE: You cannot build a custom name based on another custom name. You can only build a custom name based on the templated variables.
*/
custom_names = {
  # Resource group names
  management_resource_group_name = "rg-management-$${starter_location_01}"

  connectivity_hub_primary_resource_group_name   = "rg-hub-$${starter_location_01}"
  connectivity_hub_secondary_resource_group_name = "rg-hub-$${starter_location_02}"
  dns_resource_group_name                        = "rg-hub-dns-$${starter_location_01}"
  ddos_resource_group_name                       = "rg-hub-ddos-$${starter_location_01}"

  # Resource names
  log_analytics_workspace_name            = "law-management-$${starter_location_01}"
  ddos_protection_plan_name               = "ddos-hub-$${starter_location_01}"
  automation_account_name                 = "aa-management-$${starter_location_01}"
  ama_user_assigned_managed_identity_name = "uami-management-ama-$${starter_location_01}"
  dcr_change_tracking_name                = "dcr-change-tracking"
  dcr_defender_sql_name                   = "dcr-defender-sql"
  dcr_vm_insights_name                    = "dcr-vm-insights"

  # Resource identifiers
  management_resource_group_id = "/subscriptions/$${subscription_id_management}/resourcegroups/rg-management-$${starter_location_01}"
}

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

management_group_settings = {
  location           = "$${starter_location_01}"
  architecture_name  = "alz"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_change_tracking_name}"
    ama_mdfc_sql_data_collection_rule_id        = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_defender_sql_name}"
    ama_vm_insights_data_collection_rule_id     = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_vm_insights_name}"
    ama_user_assigned_managed_identity_id       = "$${management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$${ama_user_assigned_managed_identity_name}"
    ama_user_assigned_managed_identity_name     = "uami-management-ama-$${starter_location_01}"
    log_analytics_workspace_id                  = "$${management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/$${log_analytics_workspace_name}"
    ddos_protection_plan_id                     = "$${management_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
  }

  /*
  # Example of how to update a policy assignment enforcement mode
  policy_assignments_to_modify = {
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
  }
  */
}

connectivity_type = "hub_and_spoke_vnet"

connectivity_resource_groups = {
  ddos = {
    name     = "$${ddos_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vnet_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
  }
  vnet_secondary = {
    name     = "$${connectivity_hub_secondary_resource_group_name}"
    location = "$${starter_location_02}"
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
  }
}

hub_and_spoke_vnet_settings = {
  ddos_protection_plan = {
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}

hub_and_spoke_vnet_virtual_networks = {
  primary = {
    hub_virtual_network = {
      name                            = "vnet-hub-$${starter_location_01}"
      resource_group_name             = "$${connectivity_hub_primary_resource_group_name}"
      resource_group_creation_enabled = false
      location                        = "$${starter_location_01}"
      address_space                   = ["10.0.0.0/16"]
      ddos_protection_plan_id         = "$${management_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
      subnets = {
        virtual_network_gateway = {
          name                         = "GatewaySubnet"
          address_prefixes             = ["10.0.1.0/24"]
          assign_generated_route_table = false
        }
      }
      firewall = {
        subnet_address_prefix = "10.0.0.0/24"
        name                  = "fw-hub-$${starter_location_01}"
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = "$${starter_location_01_availability_zones}"
        default_ip_configuration = {
          public_ip_config = {
            name       = "pip-fw-hub-$${starter_location_01}"
            zones      = "$${starter_location_01_availability_zones}"
            ip_version = "IPv4"
          }
        }
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
          dns = {
            proxy_enabled = true
          }
        }
      }
    }
    virtual_network_gateways = {
      express_route = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-expressroute-$${starter_location_01}"
        type     = "ExpressRoute"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_express_route}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-expressroute-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-expressroute-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
      vpn = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-vpn-$${starter_location_01}"
        type     = "Vpn"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_vpn}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-vpn-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-vpn-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
    }
    private_dns_zones = {
      resource_group_name = "$${dns_resource_group_name}"
      is_primary          = true
    }
  }
  secondary = {
    hub_virtual_network = {
      name                            = "vnet-hub-$${starter_location_02}"
      resource_group_name             = "$${connectivity_hub_secondary_resource_group_name}"
      resource_group_creation_enabled = false
      location                        = "$${starter_location_02}"
      address_space                   = ["10.1.0.0/16"]
      ddos_protection_plan_id         = "$${management_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
      subnets = {
        virtual_network_gateway = {
          name                         = "GatewaySubnet"
          address_prefixes             = ["10.1.1.0/24"]
          assign_generated_route_table = false
        }
      }
      firewall = {
        subnet_address_prefix = "10.1.0.0/24"
        name                  = "fw-hub-$${starter_location_02}"
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = "$${starter_location_02_availability_zones}"
        default_ip_configuration = {
          public_ip_config = {
            name       = "pip-fw-hub-$${starter_location_02}"
            zones      = "$${starter_location_02_availability_zones}"
            ip_version = "IPv4"
          }
        }
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
          dns = {
            proxy_enabled = true
          }
        }
      }
    }
    virtual_network_gateways = {
      express_route = {
        location = "$${starter_location_02}"
        name     = "vgw-hub-expressroute-$${starter_location_02}"
        type     = "ExpressRoute"
        sku      = "$${starter_location_02_virtual_network_gateway_sku_express_route}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-expressroute-$${starter_location_02}"
            public_ip = {
              name  = "pip-vgw-hub-expressroute-$${starter_location_02}"
              zones = "$${starter_location_02_availability_zones}"
            }
          }
        }
      }
      vpn = {
        location = "$${starter_location_02}"
        name     = "vgw-hub-vpn-$${starter_location_02}"
        type     = "Vpn"
        sku      = "$${starter_location_02_virtual_network_gateway_sku_vpn}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-vpn-$${starter_location_02}"
            public_ip = {
              name  = "pip-vgw-hub-vpn-$${starter_location_02}"
              zones = "$${starter_location_02_availability_zones}"
            }
          }
        }
      }
    }
    private_dns_zones = {
      resource_group_name = "$${dns_resource_group_name}"
      is_primary          = false
    }
  }
}
