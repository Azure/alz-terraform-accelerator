provider "azurerm" {
  features {}
  subscription_id = var.sub_id_management
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id_connectivity
  alias           = "connectivity"
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id_identity
  alias           = "identity"
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id_management
  alias           = "management"
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id_app000001
  alias           = "app000001"
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id_app000002
  alias           = "app000002"
}
