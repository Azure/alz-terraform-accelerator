module "regions" {
  source                    = "Azure/avm-utl-regions/azurerm"
  version                   = "0.3.0"
  use_cached_data           = false
  availability_zones_filter = false
  recommended_filter        = false
  enable_telemetry          = var.enable_telemetry
}

data "azurerm_client_config" "current" {}
