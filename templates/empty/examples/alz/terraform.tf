terraform {
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.20"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  backend "azurerm" {}
}


provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "management"
  subscription_id                 = var.subscription_ids["management"]
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "connectivity"
  subscription_id                 = var.subscription_ids["connectivity"]
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "identity"
  subscription_id                 = var.subscription_ids["identity"]
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "security"
  subscription_id                 = var.subscription_ids["security"]
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}

provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/slz"
      ref  = "2025.09.3"
    }
  ]
}
