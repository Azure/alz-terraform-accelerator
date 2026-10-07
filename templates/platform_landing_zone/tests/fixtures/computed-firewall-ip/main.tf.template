resource "terraform_data" "public_ip" {
  input = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-computed"
}

module "sut" {
  source = "./.terraform/starter"

  providers = {
    alz                  = alz
    azapi                = azapi
    azapi.connectivity   = azapi.connectivity
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
    local                = local
  }

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

  virtual_hubs = {
    primary = {
      location = "$${starter_location_01}"
      firewall = {
        ip_configurations = {
          computed = {
            name                 = "ipconfig-$${starter_location_01_short}"
            public_ip_address_id = terraform_data.public_ip.output
          }
          literal = {
            name                 = "ipconfig-literal"
            public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-literal"
          }
        }
      }
    }
    secondary = { location = "$${starter_location_02}" }
  }
}

output "hubs" {
  value = module.sut.templated_inputs.virtual_hubs
}

output "public_ip_address_id" {
  value = terraform_data.public_ip.output
}
