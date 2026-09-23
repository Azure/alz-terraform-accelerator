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
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000001"
      subscription_id = "00000000-0000-0000-0000-000000000003"
    }
  }
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
  mock_data "azapi_resource_list" {
    defaults = {
      output = { firewalls = [] }
    }
  }
}
mock_provider "azapi" {
  alias = "connectivity"
  mock_data "azapi_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000001"
      subscription_id = "00000000-0000-0000-0000-000000000003"
    }
  }
  mock_data "azapi_resource_action" {
    defaults = {
      output = {
        value = [
          {
            name        = "eastus"
            displayName = "East US"
            metadata = {
              geography      = "US"
              geographyGroup = "US"
              pairedRegion   = [{ name = "westus" }]
              regionCategory = "Recommended"
              regionType     = "Physical"
            }
            availabilityZoneMappings = [
              { logicalZone = "1" },
              { logicalZone = "2" },
              { logicalZone = "3" },
            ]
          },
          {
            name        = "westus"
            displayName = "West US"
            metadata = {
              geography      = "US"
              geographyGroup = "US"
              pairedRegion   = [{ name = "eastus" }]
              regionCategory = "Recommended"
              regionType     = "Physical"
            }
            availabilityZoneMappings = [
              { logicalZone = "1" },
              { logicalZone = "2" },
              { logicalZone = "3" },
            ]
          },
        ]
      }
    }
  }
  mock_data "azapi_resource_list" {
    defaults = {
      output = { firewalls = [] }
    }
  }
}
mock_provider "local" {}
mock_provider "random" {}
mock_provider "time" {}

variables {
  starter_locations       = ["eastus", "westus"]
  starter_locations_short = { starter_location_01_short = "eus" }
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

# --- Firewall-focused nonzero-hub checks -----------------------------------
# These three runs isolate the customer-IP/firewall consumer path by
# deliberately disabling the OTHER, unrelated default-on topology resources
# (bastion, ExpressRoute/VPN gateways, private DNS zones/resolver, sidecar
# virtual network) on each hub. They are narrow firewall-behavior checks, not
# full-topology regression coverage - see
# "virtual_wan_enabled_nonzero_mixed_default_on_topology" below for that.

run "virtual_wan_enabled_nonzero_customer_only_firewall_focused" {
  command = plan

  variables {
    connectivity_type = "virtual_wan"
    virtual_wan_settings = {
      enabled_resources = { ddos_protection_plan = false }
      virtual_wan = {
        name                = "vwan-test"
        location            = "eastus"
        resource_group_name = "rg-connectivity"
      }
    }
    virtual_hubs = {
      customer_hub = {
        location          = "eastus"
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus"
        enabled_resources = {
          firewall                              = true
          firewall_policy                       = true
          bastion                               = false
          virtual_network_gateway_express_route = false
          virtual_network_gateway_vpn           = false
          private_dns_zones                     = false
          private_dns_resolver                  = false
          sidecar_virtual_network               = false
        }
        firewall = {
          ip_configurations = {
            primary = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = length(module.virtual_wan) == 1
    error_message = "Enabling virtual_wan with a single customer-IP hub must create exactly one module instance."
  }

  assert {
    condition     = length(local.virtual_hubs.customer_hub.firewall.ip_configurations) == 1
    error_message = "Customer-only nonzero hub must retain its single ip_configurations entry."
  }
}

run "virtual_wan_enabled_nonzero_managed_only_firewall_focused" {
  command = plan

  variables {
    connectivity_type = "virtual_wan"
    virtual_wan_settings = {
      enabled_resources = { ddos_protection_plan = false }
      virtual_wan = {
        name                = "vwan-test"
        location            = "eastus"
        resource_group_name = "rg-connectivity"
      }
    }
    virtual_hubs = {
      managed_hub = {
        location          = "westus"
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-wus"
        enabled_resources = {
          firewall                              = true
          firewall_policy                       = true
          bastion                               = false
          virtual_network_gateway_express_route = false
          virtual_network_gateway_vpn           = false
          private_dns_zones                     = false
          private_dns_resolver                  = false
          sidecar_virtual_network               = false
        }
        firewall = {
          vhub_public_ip_count = "1"
        }
      }
    }
  }

  assert {
    condition     = length(module.virtual_wan) == 1
    error_message = "Enabling virtual_wan with a single managed-only hub must create exactly one module instance."
  }

  assert {
    condition     = length(local.virtual_hubs.managed_hub.firewall.ip_configurations) == 0
    error_message = "Managed-only nonzero hub must have an empty (not customer) ip_configurations map."
  }
}

run "virtual_wan_enabled_nonzero_mixed_firewall_focused" {
  command = plan

  variables {
    connectivity_type = "virtual_wan"
    virtual_wan_settings = {
      enabled_resources = { ddos_protection_plan = false }
      virtual_wan = {
        name                = "vwan-test"
        location            = "eastus"
        resource_group_name = "rg-connectivity"
      }
    }
    virtual_hubs = {
      customer_hub = {
        location          = "eastus"
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus"
        enabled_resources = {
          firewall                              = true
          firewall_policy                       = true
          bastion                               = false
          virtual_network_gateway_express_route = false
          virtual_network_gateway_vpn           = false
          private_dns_zones                     = false
          private_dns_resolver                  = false
          sidecar_virtual_network               = false
        }
        firewall = {
          ip_configurations = {
            primary = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
      }
      managed_hub = {
        location          = "westus"
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-wus"
        enabled_resources = {
          firewall                              = true
          firewall_policy                       = true
          bastion                               = false
          virtual_network_gateway_express_route = false
          virtual_network_gateway_vpn           = false
          private_dns_zones                     = false
          private_dns_resolver                  = false
          sidecar_virtual_network               = false
        }
        firewall = {
          vhub_public_ip_count = "1"
        }
      }
    }
  }

  assert {
    condition     = length(module.virtual_wan) == 1
    error_message = "Enabling virtual_wan with mixed hubs must still create exactly one virtual_wan module instance."
  }

  assert {
    condition = (
      length(local.virtual_hubs.customer_hub.firewall.ip_configurations) == 1 &&
      length(local.virtual_hubs.managed_hub.firewall.ip_configurations) == 0 &&
      local.virtual_hubs.managed_hub.firewall.vhub_public_ip_count == "1"
    )
    error_message = "Mixed managed/customer hubs in the same deployment must retain their independent, correct shapes."
  }

  assert {
    condition     = output.templated_inputs.virtual_hubs == local.virtual_hubs
    error_message = "The stable templated_inputs output interface must reflect the mixed-topology hub set."
  }
}

# --- Default-on, full-topology mixed-hub interoperability check ------------
# This run does NOT disable the other default-on topology resources. It
# mirrors a verified live deployment topology: one
# primary hub with a managed (Premium) firewall and a separate secondary hub
# with a customer-owned (Standard) firewall IP, while bastion, the VPN and
# ExpressRoute gateways, private DNS zones/resolver and the sidecar virtual
# network all remain enabled at their real defaults on both hubs. It proves
# the customer-IP feature does not disable, or get disabled by, sibling
# default-on topology resources - not just that the templated_inputs copy is
# unchanged.
run "virtual_wan_enabled_nonzero_mixed_default_on_topology" {
  command = plan

  variables {
    connectivity_type = "virtual_wan"
    virtual_wan_settings = {
      enabled_resources = { ddos_protection_plan = false }
      virtual_wan = {
        name                = "vwan-test"
        location            = "eastus"
        resource_group_name = "rg-connectivity"
      }
    }
    virtual_hubs = {
      primary = {
        location          = "eastus"
        is_primary        = true
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus"
        firewall = {
          sku_tier             = "Premium"
          vhub_public_ip_count = "1"
        }
        virtual_network_gateways = {
          vpn = {
            bgp_settings = {
              asn         = 65515
              peer_weight = 0
              instance_0_bgp_peering_address = {
                custom_ips = ["169.254.21.5"]
              }
              instance_1_bgp_peering_address = {
                custom_ips = ["169.254.21.9"]
              }
            }
          }
        }
      }
      secondary = {
        location          = "westus"
        default_parent_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-wus"
        firewall = {
          sku_tier = "Standard"
          ip_configurations = {
            primary = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-wus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
        virtual_network_gateways = {
          vpn = {
            bgp_settings = {
              asn         = 65515
              peer_weight = 0
              instance_0_bgp_peering_address = {
                custom_ips = ["169.254.22.5"]
              }
              instance_1_bgp_peering_address = {
                custom_ips = ["169.254.22.9"]
              }
            }
          }
        }
      }
    }
  }

  # This asserts that every default-on resource flag resolves to true in
  # var.virtual_hubs (i.e. this test does not disable any sibling resource -
  # the defaults are left in effect). It proves the *input* is genuinely
  # default-on; it is not, by itself, evidence that the underlying AVM
  # submodules were created - that is established instead by this run
  # succeeding at all: with defaults on, a real crash in any default-on
  # submodule would fail the `plan` outright, since disabling isn't used to
  # route around it here.
  assert {
    condition = alltrue([
      for hub in var.virtual_hubs : (
        hub.enabled_resources.firewall &&
        hub.enabled_resources.firewall_policy &&
        hub.enabled_resources.bastion &&
        hub.enabled_resources.virtual_network_gateway_express_route &&
        hub.enabled_resources.virtual_network_gateway_vpn &&
        hub.enabled_resources.private_dns_zones &&
        hub.enabled_resources.private_dns_resolver &&
        hub.enabled_resources.sidecar_virtual_network
      )
    ])
    error_message = "Every normally default-on topology resource must remain enabled (true) on both hubs; the customer-IP feature must not require disabling siblings."
  }

  assert {
    condition = (
      length(local.virtual_hubs.primary.firewall.ip_configurations) == 0 &&
      local.virtual_hubs.primary.firewall.vhub_public_ip_count == "1" &&
      local.virtual_hubs.primary.firewall.sku_tier == "Premium" &&
      length(local.virtual_hubs.secondary.firewall.ip_configurations) == 1 &&
      local.virtual_hubs.secondary.firewall.sku_tier == "Standard"
    )
    error_message = "The managed-Premium-primary / customer-Standard-secondary topology verified against a live deployment must forward correctly alongside the other enabled resources."
  }

  # This only checks that the virtual_wan module itself is instantiated once;
  # it does not assert that the sibling submodules' per-hub for_each maps are
  # non-empty (that would require a separate, more specific assertion against
  # each submodule's planned instances, which this test does not add). The
  # evidence that the sibling default-on resources were not silently skipped
  # is that this whole run reaches a successful `plan` with every
  # enabled_resources flag left at true (see the assertion above) rather than
  # erroring - not this count check alone.
  assert {
    condition     = length(module.virtual_wan) == 1
    error_message = "Enabling virtual_wan with a default-on, mixed-firewall-mode topology must still create exactly one virtual_wan module instance."
  }

  assert {
    condition     = output.templated_inputs.virtual_hubs == local.virtual_hubs
    error_message = "The stable templated_inputs output interface must reflect the default-on mixed topology."
  }
}

# --- Other-topology inertness (default/no-feature managed mode) ------------
run "hub_and_spoke_topology_ignores_customer_ip_shaped_hubs" {
  command = plan

  variables {
    connectivity_type = "hub_and_spoke_vnet"
    hub_and_spoke_networks_settings = {
      hub_virtual_networks = {
        primary = {
          location            = "eastus"
          resource_group_name = "rg-hs"
          vnet = {
            name          = "vnet-hub"
            address_space = ["10.0.0.0/16"]
          }
        }
      }
    }
    virtual_hubs = {
      shaped = {
        location = "eastus"
        firewall = {
          ip_configurations = {
            primary = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = length(module.virtual_wan) == 0
    error_message = "hub_and_spoke_vnet mode must never instantiate the virtual_wan module regardless of virtual_hubs content."
  }

  assert {
    condition     = length(local.virtual_hubs.shaped.firewall.ip_configurations) == 1
    error_message = "The forwarding local must still resolve even when the topology never consumes it (no crash)."
  }

  assert {
    condition     = length(module.hub_and_spoke_vnet) == 1
    error_message = "The selected hub_and_spoke_vnet topology must still be created normally."
  }
}
