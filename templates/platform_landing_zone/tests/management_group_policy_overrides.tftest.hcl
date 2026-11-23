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
}

run "new_policy_overrides_survive_config_templating" {
  command = plan

  variables {
    management_group_settings = {
      parent_resource_id    = "$${root_parent_management_group_id}"
      location              = "$${starter_location_01}"
      policy_default_values = {}
      policy_assignments_to_modify = {
        root = {
          policy_assignments = {
            external = {
              policy_definition_id     = "/providers/Microsoft.Management/managementGroups/$${root_parent_management_group_id}/providers/Microsoft.Authorization/policyDefinitions/external"
              role_assignments_enabled = false
              parameters = {
                location = "$${starter_location_01}"
              }
            }
          }
        }
      }
      subscription_placement = {}
    }
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.external.policy_definition_id == "/providers/Microsoft.Management/managementGroups/00000000-0000-0000-0000-000000000001/providers/Microsoft.Authorization/policyDefinitions/external", false)
    error_message = "External policy definition IDs must survive token replacement and policy override reconstruction."
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.external.role_assignments_enabled == false, false)
    error_message = "Disabling policy role assignments must survive policy override reconstruction."
  }

  assert {
    condition     = local.policy_assignments_to_modify.root.policy_assignments.external.parameters.location == "{\"value\":\"eastus\"}"
    error_message = "Existing policy parameter JSON encoding must remain unchanged."
  }
}

run "omitted_policy_overrides_preserve_upstream_defaults" {
  command = plan

  variables {
    management_group_settings = {
      parent_resource_id    = "$${root_parent_management_group_id}"
      location              = "$${starter_location_01}"
      policy_default_values = {}
      policy_assignments_to_modify = {
        root = {
          policy_assignments = {
            existing = {
              enforcement_mode = "DoNotEnforce"
            }
          }
        }
      }
      subscription_placement = {}
    }
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.existing.policy_definition_id == null, false)
    error_message = "Omitting a policy definition override must retain the library definition."
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.existing.role_assignments_enabled == true, false)
    error_message = "Policy role assignments must remain enabled when the new override is omitted."
  }

  assert {
    condition     = local.policy_assignments_to_modify.root.policy_assignments.existing.enforcement_mode == "DoNotEnforce"
    error_message = "Existing enforcement mode overrides must remain unchanged."
  }
}

run "empty_policy_definition_id_retains_library_definition" {
  command = plan

  variables {
    management_group_settings = {
      parent_resource_id    = "$${root_parent_management_group_id}"
      location              = "$${starter_location_01}"
      policy_default_values = {}
      policy_assignments_to_modify = {
        root = {
          policy_assignments = {
            existing = {
              policy_definition_id = ""
            }
            blank = {
              policy_definition_id = " "
            }
          }
        }
      }
      subscription_placement = {}
    }
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.existing.policy_definition_id == null, false)
    error_message = "An empty policy definition override must retain the library definition."
  }

  assert {
    condition     = try(local.policy_assignments_to_modify.root.policy_assignments.blank.policy_definition_id == null, false)
    error_message = "A whitespace-only policy definition override must retain the library definition."
  }
}
