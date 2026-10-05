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

run "apply_time_ip_id_keeps_hub_and_configuration_keys_known" {
  command = plan

  assert {
    condition     = toset(keys(output.hubs)) == toset(["primary", "secondary"])
    error_message = "An apply-time public IP ID must not make stable hub keys unknown."
  }

  assert {
    condition = (
      toset(keys(output.hubs.primary.firewall.ip_configurations)) == toset(["computed", "literal"]) &&
      output.hubs.primary.firewall.ip_configurations.computed.name == "ipconfig-eus" &&
      output.hubs.primary.firewall.ip_configurations.literal.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-literal" &&
      output.hubs.secondary.location == "westus"
    )
    error_message = "Only the computed IP ID may be unknown; configuration keys, names, and unrelated hubs must remain plan-known."
  }
}

run "apply_time_ip_id_is_restored_after_apply" {
  command = apply

  assert {
    condition = (
      output.hubs.primary.firewall.ip_configurations.computed.public_ip_address_id == output.public_ip_address_id &&
      output.hubs.primary.firewall.ip_configurations.computed.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-computed"
    )
    error_message = "The resolved customer-owned IP ID must be restored at its original hub/configuration key."
  }
}
