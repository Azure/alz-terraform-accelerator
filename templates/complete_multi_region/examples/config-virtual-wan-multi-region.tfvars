# This file contains templated variables to avoid repeating the same hard-coded values.
# Templated variables are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each templated variable that you can use:
# `starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_02` to `starter_location_10`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_01_availability_zones` to `starter_location_10_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
# `starter_location_01_virtual_network_gateway_sku` to `starter_location_10_virtual_network_gateway_sku`: These are the default SKUs for the virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
# `root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
# `subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
# `subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
# `subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.

management_use_avm = false
management_settings_es = {
  default_location              = "$${starter_location_01}"
  root_parent_id                = "$${root_parent_management_group_id}"
  root_id                       = "alz"
  root_name                     = "Azure-Landing-Zones"
  subscription_id_connectivity  = "$${subscription_id_connectivity}"
  subscription_id_identity      = "$${subscription_id_identity}"
  subscription_id_management    = "$${subscription_id_management}"
  deploy_connectivity_resources = false
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

connectivity_type = "virtual_wan"

connectivity_resource_groups = {
  ddos = {
    name     = "rg-hub-ddos-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
  vwam = {
    name     = "rg-vwan-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
  vnet_primary = {
    name     = "rg-vwan-hub-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
  vnet_secondary = {
    name     = "rg-vwan-hub-$${starter_location_02}"
    location = "$${starter_location_02}"
  }
  dns = {
    name     = "rg-hub-dns-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
}

virtual_wan_settings = {
  name                = "vwan-hub-$${starter_location_01}"
  resource_group_name = "rg-vwan-$${starter_location_01}"
  location            = "$${starter_location_01}"
  ddos_protection_plan = {
    name                = "ddos-hub-$${starter_location_01}"
    resource_group_name = "rg-hub-ddos-$${starter_location_01}"
    location            = "$${starter_location_01}"
  }
}

virtual_wan_virtual_hubs = {
  primary = {
    hub = {
      name                = "vwan-hub-$${starter_location_01}"
      resource_group_name = "rg-vwan-hub-$${starter_location_01}"
      location            = "$${starter_location_01}"
      address_prefix      = "10.0.0.0/16"
    }
    firewall = {
      name     = "fw-hub-$${starter_location_01}"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      zones    = "$${starter_location_01_availability_zones}"
      firewall_policy = {
        name = "fwp-hub-$${starter_location_01}"
      }
    }
    private_dns_zones = {
      resource_group_name = "rg-vwan-dns-$${starter_location_01}"
      is_primary          = true
      networking = {
        virtual_network = {
          name          = "vnet-hub-dns-$${starter_location_01}"
          address_space = "10.10.0.0/24"
          private_dns_resolver_subnet = {
            name           = "subnet-hub-dns-$${starter_location_01}"
            address_prefix = "10.10.0.0/28"
          }
        }
        private_dns_resolver = {
          name = "pdr-hub-dns-$${starter_location_01}"
        }
      }
    }
  }
  secondary = {
    hub = {
      name                = "vwan-hub-$${starter_location_02}"
      resource_group_name = "rg-vwan-hub-$${starter_location_02}"
      location            = "$${starter_location_02}"
      address_prefix      = "10.1.0.0/16"
    }
    firewall = {
      name     = "fw-hub-$${starter_location_02}"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      zones    = "$${starter_location_02_availability_zones}"
      firewall_policy = {
        name = "fwp-hub-$${starter_location_02}"
      }
    }
    private_dns_zones = {
      resource_group_name = "rg-vwan-dns-$${starter_location_01}"
      is_primary          = false
      networking = {
        virtual_network = {
          name          = "vnet-hub-dns-$${starter_location_02}"
          address_space = "10.11.0.0/24"
          private_dns_resolver_subnet = {
            name           = "subnet-hub-dns-$${starter_location_02}"
            address_prefix = "10.11.0.0/28"
          }
        }
        private_dns_resolver = {
          name = "pdr-hub-dns-$${starter_location_02}"
        }
      }
    }
  }
}
