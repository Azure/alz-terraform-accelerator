variable "hub_and_spoke_networks_settings" {
  type = object({
    enabled_resources = optional(object({
      ddos_protection_plan = optional(any, true)
    }), {})
    ddos_protection_plan = optional(object({
      name                = optional(string)
      location            = optional(string)
      resource_group_name = optional(string)
      tags                = optional(map(string), null)
    }), {})
  })
  default     = {}
  description = <<DESCRIPTION
The shared settings for the hub and spoke networks. This is where global resources are defined that can be shared across multiple hub networks.

- `enabled_resources` - (Optional) An object that controls which shared resources are enabled. The object has the following fields:
  - `ddos_protection_plan` - (Optional) Should the DDoS Protection Plan be created? Default `true`.

## DDoS Protection Plan

- `ddos_protection_plan` - (Optional) An object defining the DDoS protection plan settings. When configured, this DDoS protection plan can be associated with hub virtual networks. The object has the following fields:
  - `name` - (Optional) The name of the DDoS protection plan resource.
  - `location` - (Optional) The Azure location where the DDoS protection plan should be created. This should typically match the location of the hub networks that will use it.
  - `resource_group_name` - (Optional) The name of the resource group where the DDoS protection plan should be created.
  - `tags` - (Optional) A map of tags to apply to the DDoS protection plan resource.

DESCRIPTION
}

variable "hub_virtual_networks" {
  type = map(object({
    enabled_resources = optional(object({
      firewall                              = optional(any, true)
      firewall_policy                       = optional(any, true)
      bastion                               = optional(any, true)
      virtual_network_gateway_express_route = optional(any, true)
      virtual_network_gateway_vpn           = optional(any, true)
      private_dns_zones                     = optional(any, true)
      private_dns_resolver                  = optional(any, true)
    }), {})

    default_hub_address_space = optional(string)
    default_parent_id         = optional(string)
    location                  = string

    hub_virtual_network = optional(object({
      name                             = optional(string)
      address_space                    = optional(list(string))
      parent_id                        = optional(string)
      route_table_firewall_enabled     = optional(bool, true)
      route_table_user_subnets_enabled = optional(bool, true)
      route_table_name_firewall        = optional(string)
      route_table_name_user_subnets    = optional(string)
      bgp_community                    = optional(string)
      ddos_protection_plan_id          = optional(string)
      dns_servers                      = optional(list(string))
      flow_timeout_in_minutes          = optional(number, 4)
      mesh_peering_enabled             = optional(bool, true)
      peering_names                    = optional(map(string))
      routing_address_space            = optional(list(string), [])
      hub_router_ip_address            = optional(string)
      tags                             = optional(map(string))

      route_table_entries_firewall = optional(set(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
        has_bgp_override    = optional(bool, false)
        next_hop_ip_address = optional(string)
      })), [])

      route_table_entries_user_subnets = optional(set(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
        has_bgp_override    = optional(bool, false)
        next_hop_ip_address = optional(string)
      })), [])

      subnets = optional(map(object(
        {
          name             = string
          address_prefixes = list(string)
          nat_gateway = optional(object({
            id = string
          }))
          network_security_group = optional(object({
            id = string
          }))
          private_endpoint_network_policies_enabled     = optional(bool, true)
          private_link_service_network_policies_enabled = optional(bool, true)
          route_table = optional(object({
            id                           = optional(string)
            assign_generated_route_table = optional(bool, true)
          }))
          service_endpoints_with_location = optional(list(object({
            service   = string
            locations = optional(list(string))
          })))
          service_endpoint_policy_ids = optional(set(string))
          delegations = optional(list(
            object(
              {
                name = string
                service_delegation = object({
                  name    = string
                  actions = optional(list(string))
                })
              }
            )
          ))
          default_outbound_access_enabled = optional(bool, false)
        }
      )), {})
    }), {})

    firewall = optional(object({
      name                                              = optional(string)
      resource_group_name                               = optional(string)
      sku_name                                          = optional(string, "AZFW_VNet")
      sku_tier                                          = optional(string, "Standard")
      subnet_address_prefix                             = optional(string)
      subnet_default_outbound_access_enabled            = optional(bool, false)
      firewall_policy_id                                = optional(string, null)
      management_ip_enabled                             = optional(any, true)
      management_subnet_address_prefix                  = optional(string, null)
      management_subnet_default_outbound_access_enabled = optional(bool, false)
      private_ip_ranges                                 = optional(list(string))
      subnet_route_table_id                             = optional(string)
      tags                                              = optional(map(string))
      zones                                             = optional(list(string))

      default_ip_configuration = optional(object({
        is_default = optional(bool, true)
        name       = optional(string)
        public_ip_config = optional(object({
          ip_version          = optional(string, "IPv4")
          name                = optional(string)
          resource_group_name = optional(string)
          sku_tier            = optional(string, "Regional")
          zones               = optional(set(string))
          public_ip_prefix_id = optional(string)
        }), {})
      }), {})

      ip_configurations = optional(map(object({
        is_default = optional(bool, false)
        name       = optional(string)
        public_ip_config = optional(object({
          ip_version          = optional(string, "IPv4")
          name                = optional(string)
          resource_group_name = optional(string)
          sku_tier            = optional(string, "Regional")
          zones               = optional(set(string))
          public_ip_prefix_id = optional(string)
        }), {})
      })), {})

      management_ip_configuration = optional(object({
        name = optional(string)
        public_ip_config = optional(object({
          ip_version          = optional(string, "IPv4")
          name                = optional(string)
          resource_group_name = optional(string)
          sku_tier            = optional(string, "Regional")
          zones               = optional(set(string))
          public_ip_prefix_id = optional(string)
        }), {})
      }), {})
    }), {})

    firewall_policy = optional(object({
      name                              = optional(string)
      resource_group_name               = optional(string)
      sku                               = optional(string, "Standard")
      auto_learn_private_ranges_enabled = optional(bool)
      base_policy_id                    = optional(string)
      location                          = optional(string)
      dns = optional(object({
        proxy_enabled = optional(bool, false)
        servers       = optional(list(string))
      }))
      explicit_proxy = optional(object({
        enable_pac_file = optional(bool)
        enabled         = optional(bool)
        http_port       = optional(number)
        https_port      = optional(number)
        pac_file        = optional(string)
        pac_file_port   = optional(number)
      }))
      identity = optional(object({
        type         = string
        identity_ids = optional(set(string))
      }))
      insights = optional(object({
        default_log_analytics_workspace_id = string
        enabled                            = bool
        retention_in_days                  = optional(number)
        log_analytics_workspace = optional(list(object({
          firewall_location = string
          id                = string
        })))
      }))
      intrusion_detection = optional(object({
        mode           = optional(string)
        private_ranges = optional(list(string))
        signature_overrides = optional(list(object({
          id    = optional(string)
          state = optional(string)
        })))
        traffic_bypass = optional(list(object({
          description           = optional(string)
          destination_addresses = optional(set(string))
          destination_ip_groups = optional(set(string))
          destination_ports     = optional(set(string))
          name                  = string
          protocol              = string
          source_addresses      = optional(set(string))
          source_ip_groups      = optional(set(string))
        })))
      }))
      private_ip_ranges        = optional(list(string))
      sql_redirect_allowed     = optional(bool, false)
      threat_intelligence_mode = optional(string, "Alert")
      threat_intelligence_allowlist = optional(object({
        fqdns        = optional(set(string))
        ip_addresses = optional(set(string))
      }))
      tls_certificate = optional(object({
        key_vault_secret_id = string
        name                = string
      }))
    }), {})

    bastion = optional(object({
      subnet_address_prefix                  = optional(string)
      subnet_default_outbound_access_enabled = optional(bool, false)
      name                                   = optional(string)
      copy_paste_enabled                     = optional(bool, false)
      file_copy_enabled                      = optional(bool, false)
      ip_connect_enabled                     = optional(bool, false)
      kerberos_enabled                       = optional(bool, false)
      scale_units                            = optional(number, 2)
      shareable_link_enabled                 = optional(bool, false)
      sku                                    = optional(string, "Standard")
      tags                                   = optional(map(string), null)
      tunneling_enabled                      = optional(bool, false)
      zones                                  = optional(set(string), null)
      resource_group_name                    = optional(string)

      bastion_public_ip = optional(object({
        name                    = optional(string)
        allocation_method       = optional(string, "Static")
        sku                     = optional(string, "Standard")
        sku_tier                = optional(string, "Regional")
        idle_timeout_in_minutes = optional(number, 4)
        zones                   = optional(set(string), null)
        tags                    = optional(map(string), null)
        domain_name_label       = optional(string, null)
        public_ip_prefix_id     = optional(string, null)
        reverse_fqdn            = optional(string, null)
        ip_version              = optional(string, "IPv4")
        ip_tags                 = optional(map(string), {})
        edge_zone               = optional(string, null)
        ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
        ddos_protection_plan_id = optional(string, null)
        resource_group_name     = optional(string)
      }), {})
    }), {})

    virtual_network_gateways = optional(object({
      subnet_address_prefix                     = optional(string)
      subnet_default_outbound_access_enabled    = optional(bool, false)
      route_table_creation_enabled              = optional(bool, false)
      route_table_name                          = optional(string)
      route_table_bgp_route_propagation_enabled = optional(bool, false)

      express_route = optional(object({
        name      = optional(string)
        parent_id = optional(string)
        sku       = optional(string, null)
        edge_zone = optional(string)
        express_route_circuits = optional(map(object({
          id = string
          connection = optional(object({
            resource_group_name            = optional(string, null)
            authorization_key              = optional(string, null)
            express_route_gateway_bypass   = optional(bool, null)
            private_link_fast_path_enabled = optional(bool, false)
            name                           = optional(string, null)
            routing_weight                 = optional(number, null)
            shared_key                     = optional(string, null)
            tags                           = optional(map(string), {})
          }), null)
          peering = optional(object({
            peering_type                  = string
            vlan_id                       = number
            resource_group_name           = optional(string, null)
            ipv4_enabled                  = optional(bool, true)
            peer_asn                      = optional(number, null)
            primary_peer_address_prefix   = optional(string, null)
            secondary_peer_address_prefix = optional(string, null)
            shared_key                    = optional(string, null)
            route_filter_id               = optional(string, null)
            microsoft_peering_config = optional(object({
              advertised_public_prefixes = list(string)
              advertised_communities     = optional(list(string), null)
              customer_asn               = optional(number, null)
              routing_registry_name      = optional(string, null)
            }), null)
          }), null)
        })))
        express_route_remote_vnet_traffic_enabled = optional(bool, false)
        express_route_virtual_wan_traffic_enabled = optional(bool, false)
        hosted_on_behalf_of_public_ip_enabled     = optional(any, true)
        ip_configurations = optional(map(object({
          name                          = optional(string, null)
          apipa_addresses               = optional(list(string), null)
          private_ip_address_allocation = optional(string, "Dynamic")
          public_ip = optional(object({
            creation_enabled        = optional(bool, true)
            id                      = optional(string, null)
            name                    = optional(string, null)
            resource_group_name     = optional(string, null)
            allocation_method       = optional(string, "Static")
            sku                     = optional(string, "Standard")
            tags                    = optional(map(string), {})
            zones                   = optional(list(number), null)
            edge_zone               = optional(string, null)
            ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
            ddos_protection_plan_id = optional(string, null)
            domain_name_label       = optional(string, null)
            idle_timeout_in_minutes = optional(number, null)
            ip_tags                 = optional(map(string), {})
            ip_version              = optional(string, "IPv4")
            public_ip_prefix_id     = optional(string, null)
            reverse_fqdn            = optional(string, null)
            sku_tier                = optional(string, "Regional")
          }), {})
        })), {})
        local_network_gateways = optional(map(object({
          name                = optional(string, null)
          resource_group_name = optional(string, null)
          address_space       = optional(list(string), null)
          gateway_fqdn        = optional(string, null)
          gateway_address     = optional(string, null)
          tags                = optional(map(string), {})
          bgp_settings = optional(object({
            asn                 = number
            bgp_peering_address = string
            peer_weight         = optional(number, null)
          }), null)
          connection = optional(object({
            name                               = optional(string, null)
            resource_group_name                = optional(string, null)
            type                               = string
            connection_mode                    = optional(string, null)
            connection_protocol                = optional(string, null)
            dpd_timeout_seconds                = optional(number, null)
            egress_nat_rule_ids                = optional(list(string), null)
            enable_bgp                         = optional(bool, null)
            ingress_nat_rule_ids               = optional(list(string), null)
            local_azure_ip_address_enabled     = optional(bool, null)
            peer_virtual_network_gateway_id    = optional(string, null)
            routing_weight                     = optional(number, null)
            shared_key                         = optional(string, null)
            tags                               = optional(map(string), null)
            use_policy_based_traffic_selectors = optional(bool, null)
            custom_bgp_addresses = optional(object({
              primary   = string
              secondary = string
            }), null)
            ipsec_policy = optional(object({
              dh_group         = string
              ike_encryption   = string
              ike_integrity    = string
              ipsec_encryption = string
              ipsec_integrity  = string
              pfs_group        = string
              sa_datasize      = optional(number, null)
              sa_lifetime      = optional(number, null)
            }), null)
            traffic_selector_policy = optional(list(
              object({
                local_address_prefixes  = list(string)
                remote_address_prefixes = list(string)
              })
            ), null)
          }), null)
        })))
        tags     = optional(map(string))
        vpn_type = optional(string, "RouteBased")
      }), {})

      vpn = optional(object({
        name                                  = optional(string)
        parent_id                             = optional(string)
        sku                                   = optional(string, "VpnGw1AZ")
        edge_zone                             = optional(string)
        hosted_on_behalf_of_public_ip_enabled = optional(bool, false)
        ip_configurations = optional(map(object({
          name                          = optional(string, null)
          apipa_addresses               = optional(list(string), null)
          private_ip_address_allocation = optional(string, "Dynamic")
          public_ip = optional(object({
            creation_enabled        = optional(bool, true)
            id                      = optional(string, null)
            name                    = optional(string, null)
            resource_group_name     = optional(string, null)
            allocation_method       = optional(string, "Static")
            sku                     = optional(string, "Standard")
            tags                    = optional(map(string), {})
            zones                   = optional(list(number), null)
            edge_zone               = optional(string, null)
            ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
            ddos_protection_plan_id = optional(string, null)
            domain_name_label       = optional(string, null)
            idle_timeout_in_minutes = optional(number, null)
            ip_tags                 = optional(map(string), {})
            ip_version              = optional(string, "IPv4")
            public_ip_prefix_id     = optional(string, null)
            reverse_fqdn            = optional(string, null)
            sku_tier                = optional(string, "Regional")
          }), {})
          })), {
          active_active_1 = {}
          active_active_2 = {}
        })
        local_network_gateways = optional(map(object({
          name                = optional(string, null)
          resource_group_name = optional(string, null)
          address_space       = optional(list(string), null)
          gateway_fqdn        = optional(string, null)
          gateway_address     = optional(string, null)
          tags                = optional(map(string), {})
          bgp_settings = optional(object({
            asn                 = number
            bgp_peering_address = string
            peer_weight         = optional(number, null)
          }), null)
          connection = optional(object({
            name                               = optional(string, null)
            resource_group_name                = optional(string, null)
            type                               = string
            connection_mode                    = optional(string, null)
            connection_protocol                = optional(string, null)
            dpd_timeout_seconds                = optional(number, null)
            egress_nat_rule_ids                = optional(list(string), null)
            enable_bgp                         = optional(bool, null)
            ingress_nat_rule_ids               = optional(list(string), null)
            local_azure_ip_address_enabled     = optional(bool, null)
            peer_virtual_network_gateway_id    = optional(string, null)
            routing_weight                     = optional(number, null)
            shared_key                         = optional(string, null)
            tags                               = optional(map(string), null)
            use_policy_based_traffic_selectors = optional(bool, null)
            custom_bgp_addresses = optional(object({
              primary   = string
              secondary = string
            }), null)
            ipsec_policy = optional(object({
              dh_group         = string
              ike_encryption   = string
              ike_integrity    = string
              ipsec_encryption = string
              ipsec_integrity  = string
              pfs_group        = string
              sa_datasize      = optional(number, null)
              sa_lifetime      = optional(number, null)
            }), null)
            traffic_selector_policy = optional(list(
              object({
                local_address_prefixes  = list(string)
                remote_address_prefixes = list(string)
              })
            ), null)
          }), null)
        })))
        tags                                      = optional(map(string))
        vpn_active_active_enabled                 = optional(bool, true)
        vpn_bgp_enabled                           = optional(bool, false)
        vpn_bgp_route_translation_for_nat_enabled = optional(bool, false)
        vpn_bgp_settings = optional(object({
          asn         = optional(number, 65515)
          peer_weight = optional(number, null)
        }))
        vpn_custom_route = optional(object({
          address_prefixes = list(string)
        }))
        vpn_default_local_network_gateway_id = optional(string, null)
        vpn_dns_forwarding_enabled           = optional(bool, false)
        vpn_generation                       = optional(string, null)
        vpn_ip_sec_replay_protection_enabled = optional(bool, true)
        vpn_point_to_site = optional(object({
          address_space         = list(string)
          aad_tenant            = optional(string, null)
          aad_audience          = optional(string, null)
          aad_issuer            = optional(string, null)
          radius_server_address = optional(string, null)
          radius_server_secret  = optional(string, null)
          root_certificates = optional(map(object({
            name             = string
            public_cert_data = string
          })), {})
          revoked_certificates = optional(map(object({
            name       = string
            thumbprint = string
          })), {})
          radius_servers = optional(map(object({
            address = string
            secret  = string
            score   = number
          })), {})
          vpn_client_protocols = optional(list(string), null)
          vpn_auth_types       = optional(list(string), null)
          ipsec_policy = optional(object({
            dh_group                  = string
            ike_encryption            = string
            ike_integrity             = string
            ipsec_encryption          = string
            ipsec_integrity           = string
            pfs_group                 = string
            sa_data_size_in_kilobytes = optional(number, null)
            sa_lifetime_in_seconds    = optional(number, null)
          }), null)
          virtual_network_gateway_client_connections = optional(map(object({
            name               = string
            policy_group_names = list(string)
            address_prefixes   = list(string)
          })), {})
        }))
        vpn_policy_groups = optional(map(object({
          name       = string
          is_default = optional(bool, null)
          priority   = optional(number, null)
          policy_members = map(object({
            name  = string
            type  = string
            value = string
          }))
        })))
        vpn_private_ip_address_enabled = optional(bool, false)
        vpn_type                       = optional(string, null)
      }), {})
    }), {})

    private_dns_zones = optional(object({
      parent_id                        = optional(string)
      auto_registration_zone_enabled   = optional(any, true)
      auto_registration_zone_name      = optional(string, null)
      auto_registration_zone_parent_id = optional(string, null)

      private_link_excluded_zones = optional(set(string), [])
      private_link_private_dns_zones = optional(map(object({
        zone_name                              = optional(string, null)
        private_dns_zone_supports_private_link = optional(bool, true)
        resolution_policy                      = optional(string)
        custom_iterator = optional(object({
          replacement_placeholder = string
          replacement_values      = map(string)
        }))
      })))
      private_link_private_dns_zones_additional = optional(map(object({
        zone_name                              = optional(string, null)
        private_dns_zone_supports_private_link = optional(bool, true)
        resolution_policy                      = optional(string)
        custom_iterator = optional(object({
          replacement_placeholder = string
          replacement_values      = map(string)
        }))
      })))
      private_link_private_dns_zones_regex_filter = optional(object({
        enabled      = optional(bool, false)
        regex_filter = optional(string, "{regionName}|{regionCode}")
      }))
      virtual_network_link_default_virtual_networks = optional(map(object({
        virtual_network_resource_id                 = optional(string)
        virtual_network_link_name_template_override = optional(string)
        resolution_policy                           = optional(string)
      })))
      virtual_network_link_additional_virtual_networks = optional(map(object({
        virtual_network_resource_id                 = optional(string)
        virtual_network_link_name_template_override = optional(string)
        resolution_policy                           = optional(string)
      })))
      virtual_network_link_by_zone_and_virtual_network = optional(map(map(object({
        virtual_network_resource_id = optional(string, null)
        name                        = optional(string, null)
        resolution_policy           = optional(string)
      }))))
      virtual_network_link_overrides_by_zone = optional(map(object({
        virtual_network_link_name_template_override = optional(string)
        resolution_policy                           = optional(string)
        enabled                                     = optional(bool, true)
      })))
      virtual_network_link_overrides_by_virtual_network = optional(map(object({
        virtual_network_link_name_template_override = optional(string)
        resolution_policy                           = optional(string)
        enabled                                     = optional(bool, true)
      })))
      virtual_network_link_overrides_by_zone_and_virtual_network = optional(map(map(object({
        name              = optional(string)
        resolution_policy = optional(string)
        enabled           = optional(bool, true)
      }))))
      virtual_network_link_name_template             = optional(string, null)
      virtual_network_link_resolution_policy_default = optional(string)
      tags                                           = optional(map(string), null)
    }), {})

    private_dns_resolver = optional(object({
      name                                   = optional(string)
      resource_group_name                    = optional(string)
      subnet_address_prefix                  = optional(string)
      subnet_name                            = optional(string, "dns-resolver")
      subnet_default_outbound_access_enabled = optional(bool, false)
      default_inbound_endpoint_enabled       = optional(bool, true)
      ip_address                             = optional(string, null)
      inbound_endpoints = optional(map(object({
        name                         = optional(string)
        subnet_name                  = string
        private_ip_allocation_method = optional(string, "Dynamic")
        private_ip_address           = optional(string, null)
        tags                         = optional(map(string), null)
        merge_with_module_tags       = optional(bool, true)
      })), {})
      outbound_endpoints = optional(map(object({
        name                   = optional(string)
        tags                   = optional(map(string), null)
        merge_with_module_tags = optional(bool, true)
        subnet_name            = string
        forwarding_ruleset = optional(map(object({
          name                                                = optional(string)
          link_with_outbound_endpoint_virtual_network         = optional(bool, true)
          metadata_for_outbound_endpoint_virtual_network_link = optional(map(string), null)
          tags                                                = optional(map(string), null)
          merge_with_module_tags                              = optional(bool, true)
          additional_outbound_endpoint_link = optional(object({
            outbound_endpoint_key = optional(string)
          }), null)
          additional_virtual_network_links = optional(map(object({
            name     = optional(string)
            vnet_id  = string
            metadata = optional(map(string), null)
          })), {})
          rules = optional(map(object({
            name                     = optional(string)
            domain_name              = string
            destination_ip_addresses = map(string)
            enabled                  = optional(bool, true)
            metadata                 = optional(map(string), null)
          })))
        })))
      })), {})
      tags = optional(map(string), null)
    }), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of hub networks to create.

The following top level attributes are supported:

  - `enabled_resources` - (Optional) An object that controls which resources are enabled for this hub. The object has the following fields:
    - `firewall` - (Optional) Should the Azure Firewall be created? Default `true`.
    - `firewall_policy` - (Optional) Should the Azure Firewall Policy be created? Default `true`.
    - `bastion` - (Optional) Should the Azure Bastion be created? Default `true`.
    - `virtual_network_gateway_express_route` - (Optional) Should the ExpressRoute gateway be created? Default `true`.
    - `virtual_network_gateway_vpn` - (Optional) Should the VPN gateway be created? Default `true`.
    - `private_dns_zones` - (Optional) Should private DNS zones be created? Default `true`.
    - `private_dns_resolver` - (Optional) Should the private DNS resolver be created? Default `true`.
  - `default_hub_address_space` - (Optional) The default address space to use if not specified in hub_virtual_network. This defaults to `10.0.0.0/16` and increments to the next /16 for each region if not supplied.
  - `default_parent_id` - (Optional) The default parent resource group ID to use if not specified in hub_virtual_network or individual sections.
  - `location` - (Required) The Azure location where the hub network resources should be created.
  - `hub_virtual_network` - (Optional) The hub virtual network settings.
  - `firewall` - (Optional) The firewall settings.
  - `firewall_policy` - (Optional) The firewall policy settings.
  - `bastion` - (Optional) The bastion host settings.
  - `virtual_network_gateways` - (Optional) The virtual network gateway settings.
  - `private_dns_zones` - (Optional) The private DNS zone settings.
  - `private_dns_resolver` - (Optional) The private DNS resolver settings.

## Hub Virtual Network

- `hub_virtual_network` - (Optional) An object defining the hub virtual network settings. The object has the following fields:
  - `name` - (Optional) The name of the Virtual Network.
  - `address_space` - (Optional) A list of IPv4 address spaces that are used by this virtual network in CIDR format, e.g. `["192.168.0.0/24"]`.
  - `parent_id` - (Optional) The ID of the parent resource group where the virtual network should be created.
  - `route_table_firewall_enabled` - (Optional) Should the firewall route table be created? Default `true`.
  - `route_table_user_subnets_enabled` - (Optional) Should the user subnets route table be created? Default `true`.
  - `bgp_community` - The BGP community associated with the virtual network.
  - `ddos_protection_plan_id` - The ID of the DDoS protection plan associated with the virtual network.
  - `dns_servers` - A list of DNS servers IP addresses for the virtual network.
  - `flow_timeout_in_minutes` - The flow timeout in minutes for the virtual network. Default `4`.
  - `mesh_peering_enabled` - Should the virtual network be peered to other hub networks with this flag enabled? Default `true`.
  - `peering_names` - A map of the names of the peering connections to create between this virtual network and other hub networks. The key is the key of the peered hub network, and the value is the name of the peering connection.
  - `route_table_name_firewall` - The name of the route table to create for the firewall routes. Default `route-{vnetname}`.
  - `route_table_name_user_subnets` - The name of the route table to create for the user subnet routes. Default `route-{vnetname}`.
  - `routing_address_space` - A list of IPv4 address spaces in CIDR format that are used for routing to this hub, e.g. `["192.168.0.0","172.16.0.0/12"]`.
  - `hub_router_ip_address` - If not using Azure Firewall, this is the IP address of the hub router. This is used to create route table entries for other hub networks.
  - `tags` - A map of tags to apply to the virtual network.
  - `route_table_entries_firewall` - (Optional) A set of additional route table entries to add to the Firewall route table for this hub network. Default empty `[]`. The value is an object with the following fields:
    - `name` - The name of the route table entry.
    - `address_prefix` - The address prefix to match for this route table entry.
    - `next_hop_type` - The type of the next hop. Possible values include `Internet`, `VirtualAppliance`, `VirtualNetworkGateway`, `VnetLocal`, `None`.
    - `has_bgp_override` - Should the BGP override be enabled for this route table entry? Default `false`.
    - `next_hop_ip_address` - The IP address of the next hop. Required if `next_hop_type` is `VirtualAppliance`.
  - `route_table_entries_user_subnets` - (Optional) A set of additional route table entries to add to the User Subnets route table for this hub network. Default empty `[]`. The value is an object with the following fields:
    - `name` - The name of the route table entry.
    - `address_prefix` - The address prefix to match for this route table entry.
    - `next_hop_type` - The type of the next hop. Possible values include `Internet`, `VirtualAppliance`, `VirtualNetworkGateway`, `VnetLocal`, `None`.
    - `has_bgp_override` - Should the BGP override be enabled for this route table entry? Default `false`.
    - `next_hop_ip_address` - The IP address of the next hop. Required if `next_hop_type` is `VirtualAppliance`.
  - `subnets` - (Optional) A map of subnets to create in the virtual network. The value is an object with the following fields:
    - `name` - The name of the subnet.
    - `address_prefixes` - The IPv4 address prefixes to use for the subnet in CIDR format.
    - `nat_gateway` - (Optional) An object with the following fields:
      - `id` - The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
    - `network_security_group` - (Optional) An object with the following fields:
      - `id` - The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
    - `private_endpoint_network_policies_enabled` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
    - `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
    - `route_table` - (Optional) An object with the following fields which are mutually exclusive, choose either an external route table or the generated route table:
      - `id` - The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.
      - `assign_generated_route_table` - (Optional) Should the Route Table generated by this module be associated with this Subnet? Default `true`.
    - `service_endpoints_with_location` - (Optional) The list of Service endpoints to associate with the subnet.
    - `service_endpoint_policy_ids` - (Optional) The list of Service Endpoint Policy IDs to associate with the subnet.
    - `delegations` - (Optional) A list of delegation objects with the following fields:
      - `name` - The name of the delegation.
      - `service_delegation` - An object with the following fields:
        - `name` - The name of the service delegation.
        - `actions` - (Optional) A list of actions that should be delegated, the list is specific to the service being delegated.
    - `default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the subnet? Default `false`.

## Azure Firewall

- `firewall` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the firewall resource. If not specified will use `afw-{vnetname}`.
  - `resource_group_name` - (Optional) The name of the resource group where the Azure Firewall should be created. If not specified will use the parent resource group of the virtual network.
  - `sku_name` - (Optional) The name of the SKU to use for the Azure Firewall. Possible values include `AZFW_Hub`, `AZFW_VNet`. Default `AZFW_VNet`.
  - `sku_tier` - (Optional) The tier of the SKU to use for the Azure Firewall. Possible values include `Basic`, `Standard`, `Premium`. Default `Standard`.
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Azure Firewall subnet in CIDR format. Needs to be a part of the virtual network's address space.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Azure Firewall subnet? Default `false`.
  - `firewall_policy_id` - (Optional) The resource id of the Azure Firewall Policy to associate with the Azure Firewall.
  - `management_ip_enabled` - (Optional) Should the Azure Firewall management IP be enabled? Default `true`.
  - `management_subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Azure Firewall management subnet in CIDR format. Needs to be a part of the virtual network's address space.
  - `management_subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Azure Firewall management subnet? Default `false`.
  - `private_ip_ranges` - (Optional) A list of private IP ranges to use for the Azure Firewall, to which the firewall will not NAT traffic. If not specified will use RFC1918.
  - `subnet_route_table_id` = (Optional) The resource id of the Route Table which should be associated with the Azure Firewall subnet. If not specified the module will assign the generated route table.
  - `tags` - (Optional) A map of tags to apply to the Azure Firewall. If not specified
  - `zones` - (Optional) A list of availability zones to use for the Azure Firewall. If not specified will be `null`.
  - `default_ip_configuration` - (Optional) An object with the following fields. This is for legacy purpose, consider using `ip_configurations` instead. If `ip_configurations` is specified, this input will be ignored. If not specified the defaults below will be used:
    - `name` - (Optional) The name of the default IP configuration. If not specified will use `default`.
    - `is_default` - (Optional) Indicates this is the default IP configuration. This must always be `true` for the legacy configuration. If not specified will be `true`.
    - `public_ip_config` - (Optional) An object with the following fields:
      - `name` - (Optional) The name of the public IP configuration. If not specified will use `pip-fw-{vnetname}`.
      - `resource_group_name` - (Optional) The name of the resource group where the public IP should be created. If not specified will use the parent resource group of the virtual network.
      - `zones` - (Optional) A list of availability zones to use for the public IP configuration. If not specified will be `null`.
      - `ip_version` - (Optional) The IP version to use for the public IP configuration. Possible values include `IPv4`, `IPv6`. If not specified will be `IPv4`.
      - `sku_tier` - (Optional) The SKU tier to use for the public IP configuration. Possible values include `Regional`, `Global`. If not specified will be `Regional`.
      - `public_ip_prefix_id` - (Optional) The ID of the public IP prefix.
  - `ip_configurations` - (Optional) A map of the default IP configuration for the Azure Firewall. If not specified the defaults below will be used:
    - `name` - (Optional) The name of the default IP configuration. If not specified will use `default`.
    - `is_default` - (Optional) Indicates this is the default IP configuration, which will be linked to the Firewall subnet. If not specified will be `false`. At least one and only one IP configuration must have this set to `true`.
    - `public_ip_config` - (Optional) An object with the following fields:
      - `name` - (Optional) The name of the public IP configuration. If not specified will use `pip-fw-{vnetname}-<Map Key>`.
      - `resource_group_name` - (Optional) The name of the resource group where the public IP should be created. If not specified will use the parent resource group of the virtual network.
      - `zones` - (Optional) A list of availability zones to use for the public IP configuration. If not specified will be `null`.
      - `ip_version` - (Optional) The IP version to use for the public IP configuration. Possible values include `IPv4`, `IPv6`. If not specified will be `IPv4`.
      - `sku_tier` - (Optional) The SKU tier to use for the public IP configuration. Possible values include `Regional`, `Global`. If not specified will be `Regional`.
      - `public_ip_prefix_id` - (Optional) The ID of the public IP prefix.
  - `management_ip_configuration` - (Optional) An object with the following fields. If not specified the defaults below will be used:
    - `name` - (Optional) The name of the management IP configuration. If not specified will use `defaultMgmt`.
    - `public_ip_config` - (Optional) An object with the following fields:
      - `name` - (Optional) The name of the public IP configuration. If not specified will use `pip-fw-mgmt-<Map Key>`.
      - `resource_group_name` - (Optional) The name of the resource group where the public IP should be created. If not specified will use the parent resource group of the virtual network.
      - `zones` - (Optional) A list of availability zones to use for the public IP configuration. If not specified will be `null`.
      - `ip_version` - (Optional) The IP version to use for the public IP configuration. Possible values include `IPv4`, `IPv6`. If not specified will be `IPv4`.
      - `sku_tier` - (Optional) The SKU tier to use for the public IP configuration. Possible values include `Regional`, `Global`. If not specified will be `Regional`.
      - `public_ip_prefix_id` - (Optional) The ID of the public IP prefix.

## Azure Firewall Policy

- `firewall_policy` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the firewall policy. If not specified will use `afw-policy-{vnetname}`.
  - `resource_group_name` - (Optional) The name of the resource group where the firewall policy should be created. If not specified will use the parent resource group of the virtual network.
  - `location` - (Optional) The Azure location where the firewall policy should be created. If not specified will use the location of the hub network. This is included to handle a very specific edge case of a global base policy.
  - `sku` - (Optional) The SKU to use for the firewall policy. Possible values include `Standard`, `Premium`. Default `Standard`.
  - `auto_learn_private_ranges_enabled` - (Optional) Should the firewall policy automatically learn private ranges? Default `false`.
  - `base_policy_id` - (Optional) The resource id of the base policy to use for the firewall policy.
  - `dns` - (Optional) An object with the following fields:
    - `proxy_enabled` - (Optional) Should the DNS proxy be enabled for the firewall policy? Default `false`.
    - `servers` - (Optional) A list of DNS server IP addresses for the firewall policy.
  - `explicit_proxy` - (Optional) An object with the following fields:
    - `enabled` - (Optional) Should the explicit proxy be enabled?
    - `http_port` - (Optional) The port for HTTP proxy traffic.
    - `https_port` - (Optional) The port for HTTPS proxy traffic.
    - `enable_pac_file` - (Optional) Should the PAC file be enabled?
    - `pac_file_port` - (Optional) The port for the PAC file.
    - `pac_file` - (Optional) The PAC file URL.
  - `identity` - (Optional) An object with the following fields:
    - `type` - The type of Managed Service Identity (required). Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
    - `identity_ids` - (Optional) A set of User Assigned Managed Identity IDs.
  - `insights` - (Optional) An object with the following fields:
    - `enabled` - Should Azure Firewall insights be enabled? (required)
    - `default_log_analytics_workspace_id` - The ID of the default Log Analytics Workspace for Azure Firewall insights (required).
    - `retention_in_days` - (Optional) The log retention period in days.
    - `log_analytics_workspace` - (Optional) A list of objects with the following fields:
      - `id` - The ID of the Log Analytics Workspace (required).
      - `firewall_location` - The location of the firewall for this workspace (required).
  - `intrusion_detection` - (Optional) An object with the following fields:
    - `mode` - (Optional) The intrusion detection mode. Possible values are `Alert`, `Deny`, `Off`.
    - `private_ranges` - (Optional) A list of private IP ranges for intrusion detection.
    - `signature_overrides` - (Optional) A list of objects with the following fields:
      - `id` - (Optional) The signature ID.
      - `state` - (Optional) The state of the signature. Possible values are `Alert`, `Deny`, `Off`.
    - `traffic_bypass` - (Optional) A list of objects with the following fields:
      - `name` - The name of the traffic bypass rule (required).
      - `protocol` - The protocol for the traffic bypass rule (required). Possible values are `TCP`, `UDP`, `ICMP`, `Any`.
      - `description` - (Optional) The description of the traffic bypass rule.
      - `destination_addresses` - (Optional) A set of destination addresses.
      - `destination_ip_groups` - (Optional) A set of destination IP group IDs.
      - `destination_ports` - (Optional) A set of destination ports.
      - `source_addresses` - (Optional) A set of source addresses.
      - `source_ip_groups` - (Optional) A set of source IP group IDs.
  - `private_ip_ranges` - (Optional) A list of private IP ranges to use for the firewall policy.
  - `sql_redirect_allowed` - (Optional) Should SQL redirect be allowed? Default `false`.
  - `threat_intelligence_mode` - (Optional) The threat intelligence mode for the firewall policy. Possible values include `Alert`, `Deny`, `Off`. Default `Alert`.
  - `threat_intelligence_allowlist` - (Optional) An object with the following fields:
    - `fqdns` - (Optional) A set of FQDNs to allowlist for threat intelligence.
    - `ip_addresses` - (Optional) A set of IP addresses to allowlist for threat intelligence.
  - `tls_certificate` - (Optional) An object with the following fields:
    - `key_vault_secret_id` - The Key Vault secret ID for the TLS certificate (required).
    - `name` - The name of the TLS certificate (required).

## Azure Bastion

- `bastion` - (Optional) An object with the following fields:
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Azure Bastion subnet in CIDR format. Must be named `AzureBastionSubnet` and be a part of the virtual network's address space.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Azure Bastion subnet? Default `false`.
  - `name` - (Optional) The name of the Azure Bastion resource.
  - `copy_paste_enabled` - (Optional) Should copy-paste be enabled for the Azure Bastion? Default `false`.
  - `file_copy_enabled` - (Optional) Should file copy be enabled for the Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `ip_connect_enabled` - (Optional) Should IP connect be enabled for the Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `kerberos_enabled` - (Optional) Should Kerberos authentication be enabled for the Azure Bastion? Default `false`.
  - `scale_units` - (Optional) The number of scale units for the Azure Bastion. Valid values are between 2 and 50. Default `2`.
  - `shareable_link_enabled` - (Optional) Should shareable links be enabled for the Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `sku` - (Optional) The SKU of the Azure Bastion. Possible values are `Basic`, `Standard`. Default `Standard`.
  - `tags` - (Optional) A map of tags to apply to the Azure Bastion.
  - `tunneling_enabled` - (Optional) Should tunneling be enabled for the Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `zones` - (Optional) A set of availability zones for the Azure Bastion.
  - `resource_group_name` - (Optional) The name of the resource group where the Azure Bastion should be created. If not specified will use the parent resource group of the virtual network.
  - `bastion_public_ip` - (Optional) An object with the following fields:
    - `name` - (Optional) The name of the public IP for the Azure Bastion. If not specified will use `pip-bastion-{vnetname}`.
    - `allocation_method` - (Optional) The allocation method for the public IP. Possible values are `Static`, `Dynamic`. Default `Static`.
    - `sku` - (Optional) The SKU of the public IP. Possible values are `Basic`, `Standard`. Default `Standard`.
    - `sku_tier` - (Optional) The SKU tier of the public IP. Possible values are `Regional`, `Global`. Default `Regional`.
    - `idle_timeout_in_minutes` - (Optional) The idle timeout in minutes for the public IP. Default `4`.
    - `zones` - (Optional) A set of availability zones for the public IP.
    - `tags` - (Optional) A map of tags to apply to the public IP.
    - `domain_name_label` - (Optional) The domain name label for the public IP.
    - `public_ip_prefix_id` - (Optional) The ID of the public IP prefix.
    - `reverse_fqdn` - (Optional) The reverse FQDN for the public IP.
    - `ip_version` - (Optional) The IP version. Possible values are `IPv4`, `IPv6`. Default `IPv4`.
    - `ip_tags` - (Optional) A map of IP tags to apply to the public IP.
    - `edge_zone` - (Optional) The edge zone for the public IP.
    - `ddos_protection_mode` - (Optional) The DDoS protection mode. Possible values are `Disabled`, `Enabled`, `VirtualNetworkInherited`. Default `VirtualNetworkInherited`.
    - `ddos_protection_plan_id` - (Optional) The ID of the DDoS protection plan.
    - `resource_group_name` - (Optional) The name of the resource group where the public IP should be created. If not specified will use the bastion resource group name or the parent resource group of the virtual network.

## Virtual Network Gateways

- `virtual_network_gateways` - (Optional) An object with the following fields:
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Gateway subnet in CIDR format. Must be named `GatewaySubnet` and be a part of the virtual network's address space.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Gateway subnet? Default `false`.
  - `route_table_creation_enabled` - (Optional) Should a route table be created for the Gateway subnet? Default `false`.
  - `route_table_name` - (Optional) The name of the route table for the Gateway subnet.
  - `route_table_bgp_route_propagation_enabled` - (Optional) Should BGP route propagation be enabled for the Gateway subnet route table? Default `false`.

### ExpressRoute Gateway

- `express_route` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the ExpressRoute gateway.
  - `parent_id` - (Optional) The ID of the parent resource group. If not specified, uses the hub virtual network's parent_id.
  - `sku` - (Optional) The SKU of the ExpressRoute gateway. Possible values include `Standard`, `HighPerformance`, `UltraPerformance`, `ErGw1AZ`, `ErGw2AZ`, `ErGw3AZ`.
  - `edge_zone` - (Optional) The edge zone for the ExpressRoute gateway.
  - `express_route_circuits` - (Optional) A map of ExpressRoute circuits to connect. Each circuit is an object with:
    - `id` - The ID of the ExpressRoute circuit (required).
    - `connection` - (Optional) An object with the following fields:
      - `name` - (Optional) The name of the connection. If not specified will be auto-generated.
      - `resource_group_name` - (Optional) The resource group name for the connection.
      - `authorization_key` - (Optional) The authorization key for the ExpressRoute circuit.
      - `express_route_gateway_bypass` - (Optional) Should ExpressRoute gateway bypass be enabled?
      - `private_link_fast_path_enabled` - (Optional) Should private link fast path be enabled? Default `false`.
      - `routing_weight` - (Optional) The routing weight.
      - `shared_key` - (Optional) The shared key for the connection.
      - `tags` - (Optional) A map of tags to apply to the connection.
    - `peering` - (Optional) An object with the following fields:
      - `peering_type` - The peering type (required). Possible values are `AzurePrivatePeering`, `AzurePublicPeering`, `MicrosoftPeering`.
      - `vlan_id` - The VLAN ID for the peering (required).
      - `resource_group_name` - (Optional) The resource group name for the peering.
      - `ipv4_enabled` - (Optional) Should IPv4 be enabled? Default `true`.
      - `peer_asn` - (Optional) The peer ASN.
      - `primary_peer_address_prefix` - (Optional) The primary peer address prefix.
      - `secondary_peer_address_prefix` - (Optional) The secondary peer address prefix.
      - `shared_key` - (Optional) The shared key for the peering.
      - `route_filter_id` - (Optional) The ID of the route filter.
      - `microsoft_peering_config` - (Optional) An object with the following fields:
        - `advertised_public_prefixes` - A list of advertised public prefixes (required).
        - `advertised_communities` - (Optional) A list of advertised communities.
        - `customer_asn` - (Optional) The customer ASN.
        - `routing_registry_name` - (Optional) The routing registry name.
  - `express_route_remote_vnet_traffic_enabled` - (Optional) Should remote VNet traffic be enabled? Default `false`.
  - `express_route_virtual_wan_traffic_enabled` - (Optional) Should virtual WAN traffic be enabled? Default `false`.
  - `hosted_on_behalf_of_public_ip_enabled` - (Optional) Should hosted on behalf of public IP be enabled? Default `false`.
  - `ip_configurations` - (Optional) A map of IP configurations. Each configuration is an object with:
    - `name` - (Optional) The name of the IP configuration.
    - `apipa_addresses` - (Optional) A list of APIPA addresses.
    - `private_ip_address_allocation` - (Optional) The private IP address allocation method. Possible values are `Dynamic`, `Static`. Default `Dynamic`.
    - `public_ip` - (Optional) An object with the following fields:
      - `creation_enabled` - (Optional) Should the public IP be created? Default `true`.
      - `id` - (Optional) The ID of an existing public IP.
      - `name` - (Optional) The name of the public IP.
      - `resource_group_name` - (Optional) The resource group name for the public IP.
      - `allocation_method` - (Optional) The allocation method. Possible values are `Static`, `Dynamic`. Default `Static`.
      - `sku` - (Optional) The SKU. Possible values are `Basic`, `Standard`. Default `Standard`.
      - `tags` - (Optional) A map of tags.
      - `zones` - (Optional) A list of availability zones. Default `[1, 2, 3]`.
      - `edge_zone` - (Optional) The edge zone.
      - `ddos_protection_mode` - (Optional) The DDoS protection mode. Default `VirtualNetworkInherited`.
      - `ddos_protection_plan_id` - (Optional) The DDoS protection plan ID.
      - `domain_name_label` - (Optional) The domain name label.
      - `idle_timeout_in_minutes` - (Optional) The idle timeout in minutes.
      - `ip_tags` - (Optional) A map of IP tags.
      - `ip_version` - (Optional) The IP version. Default `IPv4`.
      - `public_ip_prefix_id` - (Optional) The public IP prefix ID.
      - `reverse_fqdn` - (Optional) The reverse FQDN.
      - `sku_tier` - (Optional) The SKU tier. Default `Regional`.
  - `local_network_gateways` - (Optional) A map of local network gateways. Each gateway is an object with:
    - `name` - (Optional) The name of the local network gateway.
    - `resource_group_name` - (Optional) The resource group name.
    - `address_space` - (Optional) A list of address spaces.
    - `gateway_fqdn` - (Optional) The gateway FQDN.
    - `gateway_address` - (Optional) The gateway IP address.
    - `tags` - (Optional) A map of tags.
    - `bgp_settings` - (Optional) An object with the following fields:
      - `asn` - The ASN (required).
      - `bgp_peering_address` - The BGP peering address (required).
      - `peer_weight` - (Optional) The peer weight.
    - `connection` - (Optional) An object with the following fields:
      - `name` - (Optional) The connection name.
      - `resource_group_name` - (Optional) The resource group name.
      - `type` - The connection type (required). Possible values are `IPsec`, `Vnet2Vnet`, `ExpressRoute`.
      - `connection_mode` - (Optional) The connection mode.
      - `connection_protocol` - (Optional) The connection protocol.
      - `dpd_timeout_seconds` - (Optional) The DPD timeout in seconds.
      - `egress_nat_rule_ids` - (Optional) A list of egress NAT rule IDs.
      - `enable_bgp` - (Optional) Should BGP be enabled?
      - `ingress_nat_rule_ids` - (Optional) A list of ingress NAT rule IDs.
      - `local_azure_ip_address_enabled` - (Optional) Should local Azure IP address be enabled?
      - `peer_virtual_network_gateway_id` - (Optional) The peer virtual network gateway ID.
      - `routing_weight` - (Optional) The routing weight.
      - `shared_key` - (Optional) The shared key.
      - `tags` - (Optional) A map of tags.
      - `use_policy_based_traffic_selectors` - (Optional) Should policy-based traffic selectors be used?
      - `custom_bgp_addresses` - (Optional) An object with the following fields:
        - `primary` - The primary BGP address (required).
        - `secondary` - The secondary BGP address (required).
      - `ipsec_policy` - (Optional) An object with the following fields:
        - `dh_group` - The DH group (required).
        - `ike_encryption` - The IKE encryption (required).
        - `ike_integrity` - The IKE integrity (required).
        - `ipsec_encryption` - The IPsec encryption (required).
        - `ipsec_integrity` - The IPsec integrity (required).
        - `pfs_group` - The PFS group (required).
        - `sa_datasize` - (Optional) The SA data size.
        - `sa_lifetime` - (Optional) The SA lifetime.
      - `traffic_selector_policy` - (Optional) A list of objects with the following fields:
        - `local_address_prefixes` - A list of local address prefixes (required).
        - `remote_address_prefixes` - A list of remote address prefixes (required).
  - `tags` - (Optional) A map of tags to apply to the ExpressRoute gateway.
  - `vpn_type` - (Optional) The VPN type. Possible values are `RouteBased`, `PolicyBased`.

### VPN Gateway

- `vpn` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the VPN gateway.
  - `parent_id` - (Optional) The ID of the parent resource group. If not specified, uses the hub virtual network's parent_id.
  - `sku` - (Optional) The SKU of the VPN gateway. Possible values include `Basic`, `VpnGw1`, `VpnGw2`, `VpnGw3`, `VpnGw4`, `VpnGw5`, `VpnGw1AZ`, `VpnGw2AZ`, `VpnGw3AZ`, `VpnGw4AZ`, `VpnGw5AZ`. Default `VpnGw1AZ`.
  - `edge_zone` - (Optional) The edge zone for the VPN gateway.
  - `hosted_on_behalf_of_public_ip_enabled` - (Optional) Should hosted on behalf of public IP be enabled? Default `false`.
  - `ip_configurations` - (Optional) A map of IP configurations. Each configuration is an object with:
    - `name` - (Optional) The name of the IP configuration.
    - `apipa_addresses` - (Optional) A list of APIPA addresses.
    - `private_ip_address_allocation` - (Optional) The private IP address allocation method. Possible values are `Dynamic`, `Static`. Default `Dynamic`.
    - `public_ip` - (Optional) An object with the following fields:
      - `creation_enabled` - (Optional) Should the public IP be created? Default `true`.
      - `id` - (Optional) The ID of an existing public IP.
      - `name` - (Optional) The name of the public IP.
      - `resource_group_name` - (Optional) The resource group name for the public IP.
      - `allocation_method` - (Optional) The allocation method. Possible values are `Static`, `Dynamic`. Default `Static`.
      - `sku` - (Optional) The SKU. Possible values are `Basic`, `Standard`. Default `Standard`.
      - `tags` - (Optional) A map of tags.
      - `zones` - (Optional) A list of availability zones.
      - `edge_zone` - (Optional) The edge zone.
      - `ddos_protection_mode` - (Optional) The DDoS protection mode. Default `VirtualNetworkInherited`.
      - `ddos_protection_plan_id` - (Optional) The DDoS protection plan ID.
      - `domain_name_label` - (Optional) The domain name label.
      - `idle_timeout_in_minutes` - (Optional) The idle timeout in minutes.
      - `ip_tags` - (Optional) A map of IP tags.
      - `ip_version` - (Optional) The IP version. Default `IPv4`.
      - `public_ip_prefix_id` - (Optional) The public IP prefix ID.
      - `reverse_fqdn` - (Optional) The reverse FQDN.
      - `sku_tier` - (Optional) The SKU tier. Default `Regional`.
  - `local_network_gateways` - (Optional) A map of local network gateways. Each gateway is an object with:
    - `name` - (Optional) The name of the local network gateway.
    - `resource_group_name` - (Optional) The resource group name.
    - `address_space` - (Optional) A list of address spaces.
    - `gateway_fqdn` - (Optional) The gateway FQDN.
    - `gateway_address` - (Optional) The gateway IP address.
    - `tags` - (Optional) A map of tags.
    - `bgp_settings` - (Optional) An object with the following fields:
      - `asn` - The ASN (required).
      - `bgp_peering_address` - The BGP peering address (required).
      - `peer_weight` - (Optional) The peer weight.
    - `connection` - (Optional) An object with the following fields:
      - `name` - (Optional) The connection name.
      - `resource_group_name` - (Optional) The resource group name.
      - `type` - The connection type (required). Possible values are `IPsec`, `Vnet2Vnet`, `ExpressRoute`.
      - `connection_mode` - (Optional) The connection mode.
      - `connection_protocol` - (Optional) The connection protocol.
      - `dpd_timeout_seconds` - (Optional) The DPD timeout in seconds.
      - `egress_nat_rule_ids` - (Optional) A list of egress NAT rule IDs.
      - `enable_bgp` - (Optional) Should BGP be enabled?
      - `ingress_nat_rule_ids` - (Optional) A list of ingress NAT rule IDs.
      - `local_azure_ip_address_enabled` - (Optional) Should local Azure IP address be enabled?
      - `peer_virtual_network_gateway_id` - (Optional) The peer virtual network gateway ID.
      - `routing_weight` - (Optional) The routing weight.
      - `shared_key` - (Optional) The shared key.
      - `tags` - (Optional) A map of tags.
      - `use_policy_based_traffic_selectors` - (Optional) Should policy-based traffic selectors be used?
      - `custom_bgp_addresses` - (Optional) An object with the following fields:
        - `primary` - The primary BGP address (required).
        - `secondary` - The secondary BGP address (required).
      - `ipsec_policy` - (Optional) An object with the following fields:
        - `dh_group` - The DH group (required).
        - `ike_encryption` - The IKE encryption (required).
        - `ike_integrity` - The IKE integrity (required).
        - `ipsec_encryption` - The IPsec encryption (required).
        - `ipsec_integrity` - The IPsec integrity (required).
        - `pfs_group` - The PFS group (required).
        - `sa_datasize` - (Optional) The SA data size.
        - `sa_lifetime` - (Optional) The SA lifetime.
      - `traffic_selector_policy` - (Optional) A list of objects with the following fields:
        - `local_address_prefixes` - A list of local address prefixes (required).
        - `remote_address_prefixes` - A list of remote address prefixes (required).
  - `tags` - (Optional) A map of tags to apply to the VPN gateway.
  - `vpn_active_active_enabled` - (Optional) Should active-active mode be enabled? Default `true`.
  - `vpn_bgp_enabled` - (Optional) Should BGP be enabled? Default `false`.
  - `vpn_bgp_route_translation_for_nat_enabled` - (Optional) Should BGP route translation for NAT be enabled? Default `false`.
  - `vpn_bgp_settings` - (Optional) An object with the following fields:
    - `asn` - (Optional) The ASN. Default `65515`.
    - `peer_weight` - (Optional) The peer weight.
  - `vpn_custom_route` - (Optional) An object with the following fields:
    - `address_prefixes` - A list of address prefixes (required).
  - `vpn_default_local_network_gateway_id` - (Optional) The default local network gateway ID.
  - `vpn_dns_forwarding_enabled` - (Optional) Should DNS forwarding be enabled? Default `false`.
  - `vpn_generation` - (Optional) The VPN generation. Possible values are `Generation1`, `Generation2`.
  - `vpn_ip_sec_replay_protection_enabled` - (Optional) Should IPsec replay protection be enabled? Default `true`.
  - `vpn_point_to_site` - (Optional) An object with the following fields:
    - `address_space` - A list of address spaces for point-to-site clients (required).
    - `aad_tenant` - (Optional) The Azure AD tenant ID.
    - `aad_audience` - (Optional) The Azure AD audience.
    - `aad_issuer` - (Optional) The Azure AD issuer.
    - `radius_server_address` - (Optional) The RADIUS server address.
    - `radius_server_secret` - (Optional) The RADIUS server secret.
    - `root_certificates` - (Optional) A map of root certificates. Each certificate is an object with:
      - `name` - The certificate name (required).
      - `public_cert_data` - The public certificate data (required).
    - `revoked_certificates` - (Optional) A map of revoked certificates. Each certificate is an object with:
      - `name` - The certificate name (required).
      - `thumbprint` - The certificate thumbprint (required).
    - `radius_servers` - (Optional) A map of RADIUS servers. Each server is an object with:
      - `address` - The server address (required).
      - `secret` - The server secret (required).
      - `score` - The server score (required).
    - `vpn_client_protocols` - (Optional) A list of VPN client protocols. Possible values are `IkeV2`, `OpenVPN`, `SSTP`.
    - `vpn_auth_types` - (Optional) A list of VPN authentication types. Possible values are `AAD`, `Certificate`, `Radius`.
    - `ipsec_policy` - (Optional) An object with the following fields:
      - `dh_group` - The DH group (required).
      - `ike_encryption` - The IKE encryption (required).
      - `ike_integrity` - The IKE integrity (required).
      - `ipsec_encryption` - The IPsec encryption (required).
      - `ipsec_integrity` - The IPsec integrity (required).
      - `pfs_group` - The PFS group (required).
      - `sa_data_size_in_kilobytes` - (Optional) The SA data size in kilobytes.
      - `sa_lifetime_in_seconds` - (Optional) The SA lifetime in seconds.
    - `virtual_network_gateway_client_connections` - (Optional) A map of client connections. Each connection is an object with:
      - `name` - The connection name (required).
      - `policy_group_names` - A list of policy group names (required).
      - `address_prefixes` - A list of address prefixes (required).
  - `vpn_policy_groups` - (Optional) A map of policy groups. Each group is an object with:
    - `name` - The policy group name (required).
    - `is_default` - (Optional) Is this the default policy group?
    - `priority` - (Optional) The priority.
    - `policy_members` - A map of policy members (required). Each member is an object with:
      - `name` - The policy member name (required).
      - `type` - The policy member type (required).
      - `value` - The policy member value (required).
  - `vpn_private_ip_address_enabled` - (Optional) Should private IP address be enabled? Default `false`.
  - `vpn_type` - (Optional) The VPN type. Possible values are `RouteBased`, `PolicyBased`.

## Private DNS Zones

- `private_dns_zones` - (Optional) An object with the following fields:
  - `parent_id` - (Optional) The resource group resource id for the private DNS zones. If not specified, uses the hub virtual network's parent resource id.
  - `auto_registration_zone_enabled` - (Optional) Should an auto-registration zone be created? Default `true`.
  - `auto_registration_zone_name` - (Optional) The name of the auto-registration zone.
  - `auto_registration_zone_parent_id` - (Optional) The resource group resource id for the auto-registration zone.
  - `private_link_excluded_zones` - (Optional) A set of private link zones to exclude from creation. Default `[]`.
  - `private_link_private_dns_zones` - (Optional) A map of private link DNS zones. Each zone is an object with:
    - `zone_name` - (Optional) The DNS zone name.
    - `private_dns_zone_supports_private_link` - (Optional) Does this zone support private link? Default `true`.
    - `resolution_policy` - (Optional) The resolution policy. Possible values are `Default` and `NxDomainRedirect`. Default value is `Default`.
    - `custom_iterator` - (Optional) An object with the following fields:
      - `replacement_placeholder` - The placeholder string to replace (required).
      - `replacement_values` - A map of replacement values (required).
  - `private_link_private_dns_zones_additional` - (Optional) A map of additional private link DNS zones. Same structure as `private_link_private_dns_zones`.
  - `private_link_private_dns_zones_regex_filter` - (Optional) An object with the following fields:
    - `enabled` - (Optional) Should regex filtering be enabled? Default `false`.
    - `regex_filter` - (Optional) The regex filter pattern. Default `{regionName}|{regionCode}`.
  - `virtual_network_link_default_virtual_networks` - (Optional) A map of default virtual network links. Each link is an object with:
    - `virtual_network_resource_id` - (Optional) The resource ID of the virtual network.
    - `virtual_network_link_name_template_override` - (Optional) Override the default name template for the virtual network link.
    - `resolution_policy` - (Optional) The resolution policy for the virtual network link. Possible values are `Default` and `NxDomainRedirect`.
  - `virtual_network_link_additional_virtual_networks` - (Optional) A map of additional virtual network links to create beyond the default virtual networks. Each link is an object with:
    - `virtual_network_resource_id` - (Optional) The resource ID of the virtual network.
    - `virtual_network_link_name_template_override` - (Optional) Override the default name template for the virtual network link.
    - `resolution_policy` - (Optional) The resolution policy for the virtual network link. Possible values are `Default` and `NxDomainRedirect`.
  - `virtual_network_link_by_zone_and_virtual_network` - (Optional) A map of maps for configuring virtual network links by specific zone and virtual network combinations. Each entry is keyed by zone, then by virtual network, with an object containing:
    - `virtual_network_resource_id` - (Optional) The resource ID of the virtual network.
    - `name` - (Optional) The name of the virtual network link.
    - `resolution_policy` - (Optional) The resolution policy. Possible values are `Default` and `NxDomainRedirect`.
  - `virtual_network_link_overrides_by_zone` - (Optional) A map of virtual network link overrides by DNS zone. The key is the Private DNS Zone map key from the `private_link_private_dns_zones` or `private_link_private_dns_zones_additional` variables. Each override is an object with:
    - `virtual_network_link_name_template_override` - (Optional) Override the default name template for virtual network links in this zone.
    - `resolution_policy` - (Optional) The resolution policy for the virtual network link. Possible values are `Default` and `NxDomainRedirect`.
    - `enabled` - (Optional) Should the virtual network link be created for this zone? Default `true`.
  - `virtual_network_link_overrides_by_virtual_network` - (Optional) A map of virtual network link overrides by virtual network. Each override is an object with:
    - `virtual_network_link_name_template_override` - (Optional) Override the default name template for virtual network links for this virtual network.
    - `resolution_policy` - (Optional) The resolution policy for the virtual network link. Possible values are `Default` and `NxDomainRedirect`.
    - `enabled` - (Optional) Should the virtual network link be created for this virtual network? Default `true`.
  - `virtual_network_link_overrides_by_zone_and_virtual_network` - (Optional) A map of maps for configuring virtual network link overrides by specific zone and virtual network combinations. Each entry is keyed by zone, then by virtual network, with an object containing:
    - `name` - (Optional) The name of the virtual network link.
    - `resolution_policy` - (Optional) The resolution policy. Possible values are `Default` and `NxDomainRedirect`.
    - `enabled` - (Optional) Should the virtual network link be created? Default `true`.
  - `virtual_network_link_name_template` - (Optional) The template for naming private DNS zone virtual network links.
  - `virtual_network_link_resolution_policy_default` - (Optional) The default resolution policy for virtual network links. Possible values are `Default` and `NxDomainRedirect`.
  - `tags` - (Optional) A map of tags to apply to the private DNS zones.

## Private DNS Resolver

- `private_dns_resolver` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the DNS resolver.
  - `resource_group_name` - (Optional) The name of the resource group where the DNS resolver should be created. If not specified, uses the hub virtual network's parent resource group.
  - `enabled` - (Optional) Should the private DNS resolver be created? Default `false`.
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the DNS resolver subnet in CIDR format. Must be a part of the virtual network's address space.
  - `subnet_name` - (Optional) The name of the DNS resolver subnet. Default `dns-resolver`.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the DNS resolver subnet? Default `false`.
  - `default_inbound_endpoint_enabled` - (Optional) Should a default inbound endpoint be created? Default `true`.
  - `ip_address` - (Optional) The IP address for the default inbound endpoint.
  - `inbound_endpoints` - (Optional) A map of additional inbound endpoints. Each endpoint is an object with:
    - `name` - (Optional) The endpoint name.
    - `subnet_name` - The subnet name for the endpoint (required).
    - `private_ip_allocation_method` - (Optional) The private IP allocation method. Possible values are `Dynamic`, `Static`. Default `Dynamic`.
    - `private_ip_address` - (Optional) The private IP address (required if allocation method is `Static`).
    - `tags` - (Optional) A map of tags.
    - `merge_with_module_tags` - (Optional) Should the tags be merged with module-level tags? Default `true`.
  - `outbound_endpoints` - (Optional) A map of outbound endpoints. Each endpoint is an object with:
    - `name` - (Optional) The endpoint name.
    - `subnet_name` - The subnet name for the endpoint (required).
    - `tags` - (Optional) A map of tags.
    - `merge_with_module_tags` - (Optional) Should the tags be merged with module-level tags? Default `true`.
    - `forwarding_ruleset` - (Optional) A map of forwarding rulesets. Each ruleset is an object with:
      - `name` - (Optional) The ruleset name.
      - `link_with_outbound_endpoint_virtual_network` - (Optional) Should the ruleset be linked with the outbound endpoint's virtual network? Default `true`.
      - `metadata_for_outbound_endpoint_virtual_network_link` - (Optional) A map of metadata for the virtual network link.
      - `tags` - (Optional) A map of tags.
      - `merge_with_module_tags` - (Optional) Should the tags be merged with module-level tags? Default `true`.
      - `additional_outbound_endpoint_link` - (Optional) An object with the following fields:
        - `outbound_endpoint_key` - (Optional) The key of another outbound endpoint to link.
      - `additional_virtual_network_links` - (Optional) A map of additional virtual network links. Each link is an object with:
        - `name` - (Optional) The link name.
        - `vnet_id` - The virtual network ID (required).
        - `metadata` - (Optional) A map of metadata.
      - `rules` - (Optional) A map of forwarding rules. Each rule is an object with:
        - `name` - (Optional) The rule name.
        - `domain_name` - The domain name for the rule (required).
        - `destination_ip_addresses` - A map of destination IP addresses (required).
        - `enabled` - (Optional) Should the rule be enabled? Default `true`.
        - `metadata` - (Optional) A map of metadata.
  - `tags` - (Optional) A map of tags to apply to the DNS resolver.

DESCRIPTION
}
