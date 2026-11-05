mock_provider "alz" {}
mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000001"
      subscription_id = "00000000-0000-0000-0000-000000000002"
    }
  }
}
mock_provider "azurerm" {
  alias = "connectivity"
}
mock_provider "azurerm" {
  alias = "management"
}
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000001"
      subscription_id = "00000000-0000-0000-0000-000000000002"
    }
  }
  mock_data "azapi_resource_action" {
    defaults = {
      output = { value = [] }
    }
  }
}
mock_provider "azapi" {
  alias = "connectivity"
}
mock_provider "local" {}
mock_provider "random" {}
mock_provider "time" {}

variables {
  starter_locations = ["eastus"]
  subscription_ids = {
    management   = "00000000-0000-0000-0000-000000000002"
    connectivity = "00000000-0000-0000-0000-000000000003"
  }
  root_parent_management_group_id = "00000000-0000-0000-0000-000000000001"
  connectivity_type               = "none"
  management_groups_enabled       = false
  management_resources_enabled    = false
  enable_telemetry                = false
  tags                            = {}
  management_resource_settings    = { location = "eastus" }
  management_group_settings = {
    parent_resource_id           = "00000000-0000-0000-0000-000000000001"
    location                     = "eastus"
    policy_default_values        = {}
    policy_assignments_to_modify = {}
    subscription_placement       = {}
  }
}

run "hub_and_spoke_vnet_v018_input_defaults" {
  command = plan

  variables {
    hub_virtual_networks = {
      hub = {
        location = "eastus"
        hub_virtual_network = {
          subnets = {
            subnet = {
              name             = "subnet"
              address_prefixes = ["10.0.1.0/24"]
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      var.hub_virtual_networks.hub.is_primary == false &&
      var.hub_virtual_networks.hub.enabled_resources.dns_resolver_policy == true &&
      var.hub_virtual_networks.hub.dns_resolver_policy == null &&
      var.hub_virtual_networks.hub.hub_virtual_network.route_table_user_subnets_bgp_propagation_enabled == true &&
      var.hub_virtual_networks.hub.hub_virtual_network.lock == null &&
      var.hub_virtual_networks.hub.hub_virtual_network.subnets.subnet.service_endpoints == null &&
      var.hub_virtual_networks.hub.hub_virtual_network.subnets.subnet.ignore_body_changes == null &&
      length(var.hub_virtual_networks.hub.firewall.default_ip_configuration.public_ip_config.ip_tags) == 0 &&
      var.hub_virtual_networks.hub.bastion.private_only_enabled == false &&
      var.hub_virtual_networks.hub.bastion.session_recording_enabled == false &&
      var.hub_virtual_networks.hub.bastion.parent_id == null
    )
    error_message = "New hub and spoke virtual network inputs must normalize to their v0.18.1 defaults when omitted."
  }

  assert {
    condition     = var.hub_virtual_networks.hub.bastion.copy_paste_enabled == false
    error_message = "The Accelerator keeps copy and paste disabled on Azure Bastion by default, unlike the module's default of true."
  }

  assert {
    condition     = length(var.ignore_body_changes.virtual_networks_virtual_network_peerings.virtual_networks_virtual_network_peerings) == 0
    error_message = "The hub-to-hub peering ignore_body_changes paths must default to an empty list."
  }
}

run "hub_and_spoke_vnet_v018_inputs_are_forwarded" {
  command = plan

  variables {
    custom_replacements = {
      names = {
        primary_dns_resolver_policy_enabled = false
      }
    }
    ignore_body_changes = {
      virtual_networks                          = ["tags"]
      virtual_networks_subnets                  = { virtual_networks_subnets = ["properties.routeTable"] }
      virtual_networks_virtual_network_peerings = { virtual_networks_virtual_network_peerings = ["properties.useRemoteGateways"] }
    }
    hub_virtual_networks = {
      primary = {
        location   = "$${starter_location_01}"
        is_primary = true
        enabled_resources = {
          dns_resolver_policy = "$${primary_dns_resolver_policy_enabled}"
        }
        hub_virtual_network = {
          route_table_user_subnets_bgp_propagation_enabled = false
          lock                                             = { kind = "CanNotDelete" }
          subnets = {
            subnet = {
              name                = "subnet"
              address_prefixes    = ["10.0.1.0/24"]
              service_endpoints   = ["Microsoft.Storage"]
              ignore_body_changes = ["properties.networkSecurityGroup"]
            }
          }
        }
        firewall = {
          default_ip_configuration = {
            public_ip_config = {
              ip_tags = { FirstPartyUsage = "/NonProd" }
            }
          }
        }
        bastion = {
          sku                       = "Premium"
          private_only_enabled      = true
          session_recording_enabled = true
          parent_id                 = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-bastion-$${starter_location_01}"
        }
        dns_resolver_policy = {
          parent_id                          = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-dns-$${starter_location_01}"
          virtual_network_link_name_template = "$$${hub_key}-$${starter_location_01}-hub"
          domain_lists = {
            blocked = { domains = ["contoso.example."] }
          }
          rules = {
            block = {
              priority         = 100
              domain_list_keys = ["blocked"]
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      local.hub_virtual_networks.primary.location == "eastus" &&
      local.hub_virtual_networks.primary.is_primary &&
      local.hub_virtual_networks.primary.enabled_resources.dns_resolver_policy == false &&
      local.hub_virtual_networks.primary.hub_virtual_network.route_table_user_subnets_bgp_propagation_enabled == false &&
      local.hub_virtual_networks.primary.hub_virtual_network.lock.kind == "CanNotDelete" &&
      local.hub_virtual_networks.primary.hub_virtual_network.subnets.subnet.service_endpoints == ["Microsoft.Storage"] &&
      local.hub_virtual_networks.primary.hub_virtual_network.subnets.subnet.ignore_body_changes == ["properties.networkSecurityGroup"] &&
      local.hub_virtual_networks.primary.firewall.default_ip_configuration.public_ip_config.ip_tags.FirstPartyUsage == "/NonProd"
    )
    error_message = "New hub-scoped inputs must survive the Accelerator's typed schema and config-templating path."
  }

  assert {
    condition = (
      local.hub_virtual_networks.primary.bastion.sku == "Premium" &&
      local.hub_virtual_networks.primary.bastion.private_only_enabled &&
      local.hub_virtual_networks.primary.bastion.session_recording_enabled &&
      local.hub_virtual_networks.primary.bastion.parent_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-bastion-eastus" &&
      local.hub_virtual_networks.primary.dns_resolver_policy.parent_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-dns-eastus" &&
      local.hub_virtual_networks.primary.dns_resolver_policy.virtual_network_link_name_template == "$${hub_key}-eastus-hub" &&
      local.hub_virtual_networks.primary.dns_resolver_policy.rules.block.domain_list_keys == ["blocked"] &&
      local.hub_virtual_networks.primary.dns_resolver_policy.rules.block.action == "Block"
    )
    error_message = "Bastion and DNS security policy inputs must be templated and keep their v0.18.1 defaults."
  }

  assert {
    condition = (
      output.templated_inputs.ignore_body_changes.virtual_networks_virtual_network_peerings.virtual_networks_virtual_network_peerings == ["properties.useRemoteGateways"] &&
      output.templated_inputs.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets == ["properties.routeTable"]
    )
    error_message = "The shared ignore_body_changes input, including hub-to-hub peering paths, must be forwarded through config templating."
  }
}

run "ignore_body_changes_rejects_blank_peering_paths" {
  command = plan

  variables {
    ignore_body_changes = {
      virtual_networks_virtual_network_peerings = { virtual_networks_virtual_network_peerings = [""] }
    }
  }

  expect_failures = [var.ignore_body_changes]
}

run "hub_and_spoke_vnet_v018_module_plan" {
  command = plan

  variables {
    connectivity_type = "hub_and_spoke_vnet"
    hub_and_spoke_networks_settings = {
      enabled_resources = {
        ddos_protection_plan = false
      }
    }
    ignore_body_changes = {
      virtual_networks_virtual_network_peerings = { virtual_networks_virtual_network_peerings = ["properties.useRemoteGateways"] }
    }
    hub_virtual_networks = {
      primary = {
        location          = "eastus"
        is_primary        = true
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-hub-eastus"
        enabled_resources = {
          virtual_network_gateway_express_route = false
          virtual_network_gateway_vpn           = false
          private_dns_zones                     = false
          private_dns_resolver                  = false
        }
        hub_virtual_network = {
          address_space = ["10.0.0.0/22"]
          lock          = { kind = "CanNotDelete" }
        }
        firewall = {
          subnet_address_prefix            = "10.0.0.0/26"
          management_subnet_address_prefix = "10.0.0.192/26"
          sku_tier                         = "Standard"
          default_ip_configuration = {
            public_ip_config = {
              ip_tags = { FirstPartyUsage = "/NonProd" }
            }
          }
        }
        bastion = {
          subnet_address_prefix = "10.0.0.64/26"
          sku                   = "Premium"
          private_only_enabled  = true
        }
        dns_resolver_policy = {
          domain_lists = {
            blocked = { domains = ["contoso.example."] }
          }
          rules = {
            block = {
              priority         = 100
              domain_list_keys = ["blocked"]
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      contains(keys(module.hub_and_spoke_vnet[0].bastion_host_resource_ids), "primary") &&
      length(module.hub_and_spoke_vnet[0].bastion_host_public_ip_address) == 0
    )
    error_message = "A private-only Premium Bastion host must be planned without a public IP by the pinned module."
  }

  assert {
    condition     = local.hub_virtual_networks.primary.dns_resolver_policy.virtual_network_link_name_template == null
    error_message = "The DNS security policy link name template must default to null so the module applies its own template instead of the Accelerator's replacements."
  }

  assert {
    condition = (
      keys(output.hub_and_spoke_vnet_dns_resolver_policy_resource_ids) == ["primary"] &&
      keys(output.hub_and_spoke_vnet_dns_resolver_policy_domain_list_resource_ids) == ["primary/blocked"] &&
      keys(output.hub_and_spoke_vnet_dns_resolver_policy_security_rule_resource_ids) == ["primary/block"]
    )
    error_message = "The DNS security policy must be planned by the pinned module and exposed through the Accelerator outputs."
  }
}
