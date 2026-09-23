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
mock_provider "modtm" {}
mock_provider "random" {}
mock_provider "time" {}

run "unknown" {
  command = plan

  assert {
    condition     = keys(output.hubs) == ["primary", "secondary"]
    error_message = "An apply-time IP ID must not make stable hub keys unknown."
  }

  assert {
    condition = (
      keys(output.hubs.primary.firewall.ip_configurations) == ["computed", "literal"] &&
      output.hubs.primary.firewall.ip_configurations.computed.name == "ipconfig-eus" &&
      output.hubs.primary.firewall.ip_configurations.literal.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-literal" &&
      output.hubs.secondary.location == "westus"
    )
    error_message = "Only the computed IP ID may be unknown; configuration keys/names and unrelated hubs must remain plan-known."
  }
}

run "resolved" {
  command = apply

  assert {
    condition = (
      output.hubs.primary.firewall.ip_configurations.computed.public_ip_address_id == output.public_ip_address_id &&
      output.hubs.primary.firewall.ip_configurations.computed.public_ip_address_id == "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-computed"
    )
    error_message = "The actual typed starter and templating path must retain the resolved customer-owned IP ID."
  }
}
