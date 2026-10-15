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

run "virtual_wan_v018_input_defaults" {
  command = plan

  variables {
    virtual_hubs = {
      hub = {
        location = "eastus"
        vpn_site_connections = {
          connection = {
            name                = "connection"
            remote_vpn_site_key = "site"
            vpn_links = [{
              name                 = "link"
              vpn_site_link_number = 0
              vpn_site_key         = "site"
            }]
          }
        }
        sidecar_virtual_network = {
          subnets = {
            subnet = {
              name             = "subnet"
              address_prefixes = ["10.0.0.0/24"]
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      var.virtual_hubs.hub.is_primary == false &&
      length(var.virtual_hubs.hub.firewall.ip_configurations) == 0 &&
      var.virtual_hubs.hub.vpn_site_connections.connection.vpn_links[0].dpd_timeout_seconds == null &&
      length(var.virtual_hubs.hub.sidecar_virtual_network.subnets.subnet.ignore_body_changes) == 0
    )
    error_message = "New Virtual WAN inputs must normalize to their v0.18.0 defaults when omitted."
  }

  assert {
    condition = (
      length(var.ignore_body_changes.virtual_hubs_firewalls) == 0 &&
      length(var.ignore_body_changes.virtual_hubs_firewalls_diagnostic_settings) == 0 &&
      length(var.ignore_body_changes.virtual_hubs_route_maps.virtual_hubs_route_maps) == 0 &&
      length(var.ignore_body_changes.virtual_networks) == 0 &&
      length(var.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets) == 0
    )
    error_message = "All shared ignore_body_changes paths must default to empty lists."
  }
}

run "virtual_wan_v018_inputs_are_forwarded" {
  command = plan

  variables {
    ignore_body_changes = {
      virtual_hubs_firewalls                     = ["tags"]
      virtual_hubs_firewalls_diagnostic_settings = ["properties.workspaceId"]
      virtual_hubs_route_maps                    = { virtual_hubs_route_maps = ["properties.rules"] }
      virtual_networks                           = ["tags"]
      virtual_networks_subnets                   = { virtual_networks_subnets = ["properties.routeTable"] }
    }
    virtual_hubs = {
      primary = {
        location   = "eastus"
        is_primary = true
        vpn_site_connections = {
          connection = {
            name                = "connection"
            remote_vpn_site_key = "site"
            vpn_links = [{
              name                 = "link"
              vpn_site_link_number = 0
              vpn_site_key         = "site"
              dpd_timeout_seconds  = 45
            }]
          }
        }
        sidecar_virtual_network = {
          subnets = {
            subnet = {
              name                = "subnet"
              address_prefixes    = ["10.0.0.0/24"]
              ignore_body_changes = ["properties.routeTable"]
            }
          }
        }
        firewall = {
          ip_configurations = {
            first = {
              name                 = "ipconfig-first"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-first"
            }
            second = {
              name                 = "ipconfig-second"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-second"
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      local.virtual_hubs.primary.is_primary &&
      local.virtual_hubs.primary.vpn_site_connections.connection.vpn_links[0].dpd_timeout_seconds == 45 &&
      local.virtual_hubs.primary.sidecar_virtual_network.subnets.subnet.ignore_body_changes == ["properties.routeTable"] &&
      local.virtual_hubs.primary.firewall.ip_configurations.first.name == "ipconfig-first" &&
      local.virtual_hubs.primary.firewall.ip_configurations.second.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-second"
    )
    error_message = "New v0.18.0 hub inputs must survive the Accelerator's typed schema and config-templating path."
  }

  assert {
    condition = (
      var.ignore_body_changes.virtual_hubs_firewalls == tolist(["tags"]) &&
      var.ignore_body_changes.virtual_hubs_firewalls_diagnostic_settings == tolist(["properties.workspaceId"]) &&
      var.ignore_body_changes.virtual_hubs_route_maps.virtual_hubs_route_maps == tolist(["properties.rules"]) &&
      var.ignore_body_changes.virtual_networks == tolist(["tags"]) &&
      var.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets == tolist(["properties.routeTable"])
    )
    error_message = "Every shared ignore_body_changes category must retain its configured path."
  }

  assert {
    condition = (
      output.templated_inputs.virtual_hubs.primary.is_primary &&
      output.templated_inputs.virtual_hubs.primary.vpn_site_connections.connection.vpn_links[0].dpd_timeout_seconds == 45 &&
      output.templated_inputs.virtual_hubs.primary.sidecar_virtual_network.subnets.subnet.ignore_body_changes == ["properties.routeTable"] &&
      output.templated_inputs.virtual_hubs.primary.firewall.ip_configurations.first.name == "ipconfig-first" &&
      output.templated_inputs.virtual_hubs.primary.firewall.ip_configurations.second.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-second"
    )
    error_message = "Every new hub-scoped input must remain present in the consumer-visible templated inputs."
  }

  assert {
    condition = (
      length(output.templated_inputs.ignore_body_changes.virtual_hubs_firewalls) == 1 &&
      output.templated_inputs.ignore_body_changes.virtual_hubs_firewalls[0] == "tags" &&
      length(output.templated_inputs.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets) == 1 &&
      output.templated_inputs.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets[0] == "properties.routeTable"
    )
    error_message = "The shared ignore_body_changes input must be forwarded through config templating."
  }
}

run "ignore_body_changes_rejects_blank_paths" {
  command = plan

  variables {
    ignore_body_changes = {
      virtual_hubs_firewalls = ["  "]
    }
  }

  expect_failures = [var.ignore_body_changes]
}
