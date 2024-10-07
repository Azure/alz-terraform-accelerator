variable "management_use_avm" {
  type        = bool
  default     = false
  description = "Flag to enable/disable the use of the AVM version of the management modules"
}

variable "management_settings_avm" {
  type    = any
  default = {}
}

variable "management_settings_es" {
  type    = any
  default = {
    default_location                                        = "$${starter_location_01}"
    root_parent_id                                          = "$${root_parent_management_group_id}"
    root_id                                                 = "alz"
    root_name                                               = "Azure-Landing-Zones"
    subscription_id_connectivity                            = "$${subscription_id_connectivity}"
    subscription_id_identity                                = "$${subscription_id_identity}"
    subscription_id_management                              = "$${subscription_id_management}"
    deploy_connectivity_resources                           = false
    configure_connectivity_resources = {
      settings = {
        dns = {
          config = {
            location = "$${starter_location_01}"
          }
        }
        ddos_protection_plan = {
          config = {
            location = "$${starter_location_01}"
          }
        }
      }
      advanced = {
        custom_settings_by_resource_type = {
          azurerm_resource_group = {
            dns = {
              ("$${starter_location_01}") = {
                name = "rg-dns-$${starter_location_01}"
              }
            }
            ddos = {
              ("$${starter_location_01}") = {
                name = "rg-ddos-$${starter_location_01}"
              }
            }
          }
          azurerm_network_ddos_protection_plan = {
            ddos = {
              ("$${starter_location_01}") = {
                name = "ddos-$${starter_location_01}"
              }
            }
          }
        }
      }
    }
    configure_management_resources = {
      location = "$${starter_location_01}"
      advanced = {
        asc_export_resource_group_name = "rg-management-asc-export-$${starter_location_01}"
        custom_settings_by_resource_type = {
          azurerm_resource_group = {
            management = {
              name = "rg-management-$${starter_location_01}"
            }
          }
        }
        azurerm_log_analytics_workspace = {
          management = {
            name = "law-management-$${starter_location_01}"
          }
        }
        azurerm_automation_account = {
          management = {
            name = "aa-management-$${starter_location_01}"
          }
        }
      }
    }
  }
}