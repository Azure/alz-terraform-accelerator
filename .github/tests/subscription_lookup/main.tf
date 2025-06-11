terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "subscription_display_name" {
  description = "The display name of the Azure subscription to look up."
  type        = string
}

data "azurerm_subscriptions" "lookup" {
  display_name_prefix = var.subscription_display_name
}

output "subscription_id" {
  description = "The ID of the Azure subscription."
  value       = data.azurerm_subscriptions.lookup.subscriptions[0].subscription_id
}
