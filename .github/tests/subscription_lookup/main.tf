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

variable "subscription_display_name_connectivity" {
  type        = string
}

variable "subscription_display_name_management" {
  type        = string
}

variable "subscription_display_name_identity" {
  type        = string
}

locals {
  subscription_display_names = {
    connectivity = var.subscription_display_name_connectivity
    management   = var.subscription_display_name_management
    identity     = var.subscription_display_name_identity
  }
}

data "azurerm_subscriptions" "lookup" {
  for_each = local.subscription_display_names
  display_name_prefix = each.value
}

output "subscription_id_connectivity" {
  value       = data.azurerm_subscriptions.lookup["connectivity"].subscriptions[0].subscription_id
}

output "subscription_id_management" {
  value       = data.azurerm_subscriptions.lookup["management"].subscriptions[0].subscription_id
}

output "subscription_id_identity" {
  value       = data.azurerm_subscriptions.lookup["identity"].subscriptions[0].subscription_id
}
