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

run "customer_ips_survive_type_conversion_and_templating" {
  command = plan

  variables {
    custom_replacements = {
      names = {
        firewall_name       = "fw-$${starter_location_01_short}"
        public_ip_name      = "pip-$${starter_location_01_short}"
        firewall_enabled    = false
        firewall_policy_sku = "Premium"
      }
      resource_group_identifiers = {
        public_ip_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-$${starter_location_01_short}"
      }
      resource_identifiers = {
        public_ip_id = "$${public_ip_resource_group_id}/providers/Microsoft.Network/publicIPAddresses/$${public_ip_name}"
      }
    }
    virtual_hubs = {
      primary = {
        location = "$${starter_location_01}"
        enabled_resources = {
          firewall = "$${firewall_enabled}"
        }
        firewall = {
          name                 = "$${firewall_name}"
          sku_tier             = "$${firewall_policy_sku}"
          vhub_public_ip_count = "0"
          ip_configurations = {
            primary = {
              name                 = "ipconfig-$${starter_location_01_short}"
              public_ip_address_id = "$${public_ip_id}"
            }
            secondary = {
              name                 = "ipconfig-secondary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-secondary"
            }
          }
        }
        firewall_policy = {
          base_policy_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-policy/providers/Microsoft.Network/firewallPolicies/base"
        }
      }
    }
  }

  assert {
    condition     = length(var.virtual_hubs.primary.firewall.ip_configurations) == 2
    error_message = "The starter's actual typed variable must retain both customer IP entries."
  }

  assert {
    condition = (
      local.virtual_hubs.primary.firewall.ip_configurations.primary.name == "ipconfig-eus" &&
      local.virtual_hubs.primary.firewall.ip_configurations.primary.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-eus" &&
      local.virtual_hubs.primary.firewall.ip_configurations.secondary == var.virtual_hubs.primary.firewall.ip_configurations.secondary
    )
    error_message = "The actual config-templating path must preserve literal IDs and resolve built-in and custom replacements."
  }

  assert {
    condition = (
      local.virtual_hubs.primary.location == "eastus" &&
      local.virtual_hubs.primary.firewall.name == "fw-eus" &&
      local.virtual_hubs.primary.firewall.sku_tier == "Premium" &&
      local.virtual_hubs.primary.firewall.vhub_public_ip_count == "0" &&
      local.virtual_hubs.primary.enabled_resources.firewall == false &&
      local.virtual_hubs.primary.firewall_policy.base_policy_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-policy/providers/Microsoft.Network/firewallPolicies/base"
    )
    error_message = "Customer IP forwarding must not change count strings, names, policy inheritance or boolean replacements."
  }

  assert {
    condition     = output.templated_inputs.virtual_hubs == local.virtual_hubs
    error_message = "The public templated_inputs output must describe the same virtual hubs passed to the pattern."
  }

  assert {
    condition = alltrue([
      for key, value in module.config.outputs :
      key == "virtual_hubs" || output.templated_inputs[key] == value
    ])
    error_message = "Restoring public IP IDs must not change the other public templated inputs."
  }
}

run "templated_keys_keep_their_matching_ids" {
  command = plan

  variables {
    virtual_hubs = {
      "hub-$${starter_location_01_short}" = {
        location = "$${starter_location_01}"
        firewall = {
          ip_configurations = {
            "ip-$${starter_location_01_short}" = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
      }
    }
  }

  assert {
    condition = (
      keys(local.virtual_hubs) == ["hub-eus"] &&
      keys(local.virtual_hubs["hub-eus"].firewall.ip_configurations) == ["ip-eus"] &&
      local.virtual_hubs["hub-eus"].firewall.ip_configurations["ip-eus"].public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
    )
    error_message = "Known template replacements in hub/configuration keys must retain their original IP association."
  }
}

run "managed_defaults_and_nullable_maps_are_preserved" {
  command = plan

  variables {
    virtual_hubs = {
      omitted = { location = "eastus" }
      null_firewall = {
        location = "eastus"
        firewall = null
      }
      null_map = {
        location = "eastus"
        firewall = { ip_configurations = null }
      }
      empty_map = {
        location = "westus"
        firewall = {
          ip_configurations    = {}
          vhub_public_ip_count = "2"
        }
      }
    }
  }

  assert {
    condition     = alltrue([for hub in var.virtual_hubs : length(hub.firewall.ip_configurations) == 0])
    error_message = "Omitted, null and empty customer IP maps must normalize to an empty typed map."
  }

  assert {
    condition = (
      local.virtual_hubs.omitted.firewall.vhub_public_ip_count == null &&
      local.virtual_hubs.null_firewall.firewall.vhub_public_ip_count == null &&
      local.virtual_hubs.null_map.firewall.vhub_public_ip_count == null &&
      local.virtual_hubs.empty_map.firewall.vhub_public_ip_count == "2" &&
      alltrue([for hub in local.virtual_hubs : hub.firewall.sku_name == "AZFW_Hub" && hub.firewall.sku_tier == "Standard"])
    )
    error_message = "The consumer must preserve the pattern's managed-count default and the existing string/SKU contract."
  }
}

run "customer_counts_remain_omitted_or_null" {
  command = plan

  variables {
    virtual_hubs = {
      primary = {
        location = "eastus"
        firewall = {
          ip_configurations = {
            existing = {
              name                 = "ipconfig-primary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
            }
          }
        }
      }
      secondary = {
        location = "westus"
        firewall = {
          vhub_public_ip_count = null
          ip_configurations = {
            existing = {
              name                 = "ipconfig-secondary"
              public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-wus/providers/Microsoft.Network/publicIPAddresses/pip-secondary"
            }
          }
        }
      }
    }
  }

  assert {
    condition = alltrue([
      for hub in local.virtual_hubs :
      hub.firewall.vhub_public_ip_count == null && length(hub.firewall.ip_configurations) == 1
    ])
    error_message = "Customer IP forwarding must not substitute a managed count for omitted or null values."
  }
}

run "disabled_connectivity_and_no_hubs_are_preserved" {
  command = plan

  assert {
    condition = (
      length(var.virtual_hubs) == 0 &&
      length(local.virtual_hubs) == 0 &&
      length(local.route_maps) == 0 &&
      length(module.virtual_wan) == 0 &&
      output.virtual_wan_full_output == null
    )
    error_message = "Customer IP support must not enable connectivity or manufacture hubs."
  }
}

run "virtual_wan_with_zero_hubs" {
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
  }

  assert {
    condition = (
      length(module.virtual_wan) == 1 &&
      length(local.virtual_hubs) == 0 &&
      length(local.route_maps) == 0
    )
    error_message = "Enabling Virtual WAN without hubs must remain valid without creating customer IP configurations."
  }
}

run "virtual_wan_receives_connectivity_providers" {
  command = plan

  assert {
    condition = (
      length(regexall("azurerm\\s*=\\s*azurerm\\.connectivity", file("${path.module}/main.connectivity.virtual.wan.tf"))) == 1 &&
      length(regexall("azapi\\s*=\\s*azapi\\.connectivity", file("${path.module}/main.connectivity.virtual.wan.tf"))) == 1 &&
      length(regexall("virtual_hubs\\s*=\\s*local\\.virtual_hubs", file("${path.module}/main.connectivity.virtual.wan.tf"))) == 1
    )
    error_message = "The Virtual WAN call must forward the tested hubs and both connectivity providers, never default management AzAPI."
  }
}

# This is an Accelerator-owned contract check, deliberately scoped to what a
# mock CAN prove: that a multi-element ip_configurations map survives the
# starter's own copied schema, the real config-templating helper, and the
# azurerm/azapi connectivity provider mapping unchanged - stable keys, exact
# names and public_ip_address_id values intact at the far end, with no
# reordering, truncation, or index-biased substitution introduced by this
# Accelerator's own code on the way in.
#
# It does NOT, and cannot, prove anything about how the pattern module (or
# Azure) resolves per-configuration attributes such as a private IP address
# from a live, heterogeneous ipConfigurations response after apply - that is
# real-ARM-shaped, ordering-dependent behavior a mock would have to author
# itself to represent, which would prove nothing. That behaviour is covered by
# the pattern module's own tests against real response shapes, not here.
run "multi_element_ip_configurations_survive_copied_schema_and_provider_mapping" {
  command = plan

  variables {
    virtual_hubs = {
      primary = {
        location = "eastus"
        firewall = {
          ip_configurations = {
            third  = { name = "ipconfig-third", public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-third" }
            first  = { name = "ipconfig-first", public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-first" }
            second = { name = "ipconfig-second", public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-second" }
          }
        }
      }
    }
  }

  assert {
    condition     = length(local.virtual_hubs.primary.firewall.ip_configurations) == 3
    error_message = "All three customer IP configuration entries must survive the copied schema and config-templating path; none may be dropped, deduplicated, or collapsed."
  }

  assert {
    condition = (
      local.virtual_hubs.primary.firewall.ip_configurations["third"].name == "ipconfig-third" &&
      local.virtual_hubs.primary.firewall.ip_configurations["third"].public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-third" &&
      local.virtual_hubs.primary.firewall.ip_configurations["first"].name == "ipconfig-first" &&
      local.virtual_hubs.primary.firewall.ip_configurations["first"].public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-first" &&
      local.virtual_hubs.primary.firewall.ip_configurations["second"].name == "ipconfig-second" &&
      local.virtual_hubs.primary.firewall.ip_configurations["second"].public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-second"
    )
    error_message = "Each configuration key must keep its own name and public_ip_address_id exactly, regardless of declaration order; no index-based reassignment or cross-entry mixing may occur in the copied schema/config-templating path."
  }

  assert {
    condition     = output.templated_inputs.virtual_hubs.primary.firewall.ip_configurations == local.virtual_hubs.primary.firewall.ip_configurations
    error_message = "The stable templated_inputs output interface must reflect all three entries exactly, unchanged, regardless of insertion order."
  }
}

