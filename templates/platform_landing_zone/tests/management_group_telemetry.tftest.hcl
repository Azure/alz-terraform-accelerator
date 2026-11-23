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
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000002"
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
  management_groups_enabled       = true
  management_resources_enabled    = false
  enable_telemetry                = true
  tags                            = {}
  management_resource_settings    = { location = "eastus" }
  management_group_settings = {
    parent_resource_id           = "$${root_parent_management_group_id}"
    location                     = "$${starter_location_01}"
    policy_default_values        = {}
    policy_assignments_to_modify = {}
    subscription_placement       = {}
  }
}

run "example_telemetry_metadata_fits_alz_deployment_name" {
  command = plan

  variables {
    telemetry_additional_content = {
      deployed_by    = "alz-terraform-accelerator"
      correlation_id = "123e4567-e89b-12d3-a456-426614174000"
    }
  }

  assert {
    condition     = length(local.management_group_telemetry_additional_content) == 2 && local.management_group_telemetry_additional_content.s == "alz" && local.management_group_telemetry_additional_content.c == "426614174000"
    error_message = "ALZ telemetry content must be s = alz plus the last correlation ID segment."
  }
}

run "omitted_telemetry_content_stays_null" {
  command = plan

  variables {
    telemetry_additional_content = null
  }

  assert {
    condition     = local.management_group_telemetry_additional_content == null
    error_message = "Omitted telemetry content must not add custom content to the ALZ deployment name."
  }
}
