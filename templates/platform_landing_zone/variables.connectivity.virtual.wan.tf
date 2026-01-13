variable "virtual_hubs" {
  type = map(object({
    enabled_resources = optional(object({
      firewall                              = optional(any, true)
      firewall_policy                       = optional(any, true)
      bastion                               = optional(any, true)
      virtual_network_gateway_express_route = optional(any, true)
      virtual_network_gateway_vpn           = optional(any, true)
      private_dns_zones                     = optional(any, true)
      private_dns_resolver                  = optional(any, true)
      sidecar_virtual_network               = optional(any, true)
    }), {})

    default_hub_address_space = optional(string)
    default_parent_id         = optional(string)
    location                  = string

    hub = optional(object({
      name                                   = optional(string)
      address_prefix                         = optional(string)
      parent_id                              = optional(string)
      sku                                    = optional(string, null)
      hub_routing_preference                 = optional(string, "ExpressRoute")
      virtual_router_auto_scale_min_capacity = optional(number, 2)
      tags                                   = optional(map(string))
    }), {})

    virtual_network_connections = optional(map(object({
      name                      = string
      remote_virtual_network_id = string
      internet_security_enabled = optional(bool)
      routing = optional(object({
        associated_route_table_id  = optional(string)
        associated_route_table_key = optional(string)
        propagated_route_table = optional(object({
          route_table_ids  = optional(list(string))
          route_table_keys = optional(list(string))
          labels           = optional(list(string))
        }))
        inbound_route_map_id  = optional(string)
        outbound_route_map_id = optional(string)
      }))
    })), {})

    express_route_circuit_connections = optional(map(object({
      name                                 = string
      express_route_circuit_peering_id     = string
      authorization_key                    = optional(string)
      enable_internet_security             = optional(bool)
      express_route_gateway_bypass_enabled = optional(bool)
      routing = optional(object({
        associated_route_table_id  = optional(string)
        associated_route_table_key = optional(string)
        propagated_route_table = optional(object({
          route_table_ids  = optional(list(string))
          route_table_keys = optional(list(string))
          labels           = optional(list(string))
        }))
        inbound_route_map_id  = optional(string)
        outbound_route_map_id = optional(string)
      }))
      routing_weight = optional(number)
    })), {})

    p2s_gateway_vpn_server_configurations = optional(map(object({
      name                     = string
      vpn_authentication_types = list(string)
      tags                     = optional(map(string))
      client_root_certificate = optional(object({
        name             = string
        public_cert_data = string
      }))
      azure_active_directory_authentication = optional(object({
        audience = string
        issuer   = string
        tenant   = string
      }))
    })), {})

    p2s_gateways = optional(map(object({
      name                                     = string
      tags                                     = optional(map(string))
      dns_servers                              = optional(list(string))
      p2s_gateway_vpn_server_configuration_key = string
      connection_configuration = object({
        name = string
        vpn_client_address_pool = object({
          address_prefixes = list(string)
        })
      })
      scale_unit = number
    })), {})

    routing_intents = optional(map(object({
      name = string
      routing_policies = list(object({
        name                  = string
        destinations          = list(string)
        next_hop_firewall_key = string
      }))
    })), {})

    vpn_site_connections = optional(map(object({
      name                = string
      remote_vpn_site_key = string
      vpn_links = list(object({
        name                 = string
        egress_nat_rule_ids  = optional(list(string))
        ingress_nat_rule_ids = optional(list(string))
        vpn_site_link_number = number
        vpn_site_key         = string
        bandwidth_mbps       = optional(number)
        bgp_enabled          = optional(bool)
        connection_mode      = optional(string, "Default")

        ipsec_policy = optional(object({
          dh_group                 = string
          ike_encryption_algorithm = string
          ike_integrity_algorithm  = string
          encryption_algorithm     = string
          integrity_algorithm      = string
          pfs_group                = string
          sa_data_size_kb          = string
          sa_lifetime_sec          = string
        }))
        protocol                              = optional(string, "IKEv2")
        ratelimit_enabled                     = optional(bool, false)
        route_weight                          = optional(number)
        shared_key                            = optional(string)
        local_azure_ip_address_enabled        = optional(bool)
        policy_based_traffic_selector_enabled = optional(bool)
        custom_bgp_addresses = optional(list(object({
          ip_address = string
          instance   = number
        })))
      }))
      internet_security_enabled = optional(bool)
      routing = optional(object({
        associated_route_table = string
        propagated_route_table = optional(object({
          route_table_ids = optional(list(string))
          labels          = optional(list(string))
        }))
        inbound_route_map_id  = optional(string)
        outbound_route_map_id = optional(string)
      }))
      traffic_selector_policy = optional(object({
        local_address_ranges  = list(string)
        remote_address_ranges = list(string)
      }))
    })), {})

    vpn_sites = optional(map(object({
      name = string
      links = list(object({
        name = string
        bgp = optional(object({
          asn             = number
          peering_address = string
        }))
        fqdn          = optional(string)
        ip_address    = optional(string)
        provider_name = optional(string)
        speed_in_mbps = optional(number)
        }
      ))
      address_cidrs = optional(list(string))
      device_model  = optional(string)
      device_vendor = optional(string)
      o365_policy = optional(object({
        traffic_category = object({
          allow_endpoint_enabled    = optional(bool)
          default_endpoint_enabled  = optional(bool)
          optimize_endpoint_enabled = optional(bool)
        })
      }))
      tags = optional(map(string))
    })), {})

    sidecar_virtual_network = optional(object({
      name          = optional(string)
      parent_id     = optional(string)
      address_space = optional(list(string))
      tags          = optional(map(string))
      ddos_protection_plan = optional(object({
        id     = string
        enable = bool
      }))
      virtual_network_connection_settings = optional(object({
        name                      = optional(string)
        internet_security_enabled = optional(bool)
        routing = optional(object({
          associated_route_table_id  = optional(string)
          associated_route_table_key = optional(string)
          propagated_route_table = optional(object({
            route_table_ids  = optional(list(string))
            route_table_keys = optional(list(string))
            labels           = optional(list(string))
          }))
          inbound_route_map_id  = optional(string)
          outbound_route_map_id = optional(string)
        }))
      }), {})
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
          service_endpoints           = optional(set(string))
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
      name                 = optional(string)
      sku_name             = optional(string, "AZFW_Hub")
      sku_tier             = optional(string, "Standard")
      zones                = optional(list(number))
      firewall_policy_id   = optional(string)
      vhub_public_ip_count = optional(string)
      tags                 = optional(map(string))
    }), {})

    firewall_policy = optional(object({
      name                              = optional(string)
      resource_group_name               = optional(string)
      sku                               = optional(string, "Standard")
      auto_learn_private_ranges_enabled = optional(bool)
      base_policy_id                    = optional(string)
      tags                              = optional(map(string))
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
        name                          = optional(string)
        allow_non_virtual_wan_traffic = optional(bool, false)
        scale_units                   = optional(number, 1)
        tags                          = optional(map(string))
      }), {})

      vpn = optional(object({
        name                                  = optional(string)
        bgp_route_translation_for_nat_enabled = optional(bool)
        bgp_settings = optional(object({
          instance_0_bgp_peering_address = optional(object({
            custom_ips = list(string)
          }))
          instance_1_bgp_peering_address = optional(object({
            custom_ips = list(string)
          }))
          peer_weight = number
          asn         = number
        }))
        routing_preference = optional(string)
        scale_unit         = optional(number)
        tags               = optional(map(string))
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
A map of Virtual WAN hubs to create.

The following top level attributes are supported:

- `enabled_resources` - (Optional) An object that controls which resources are enabled for this hub. The object has the following fields:
  - `firewall` - (Optional) Should the Azure Firewall be created? Default `true`.
  - `firewall_policy` - (Optional) Should the Azure Firewall Policy be created? Default `true`.
  - `bastion` - (Optional) Should the Azure Bastion be created? Default `true`.
  - `virtual_network_gateway_express_route` - (Optional) Should the ExpressRoute gateway be created? Default `true`.
  - `virtual_network_gateway_vpn` - (Optional) Should the VPN gateway be created? Default `true`.
  - `private_dns_zones` - (Optional) Should private DNS zones be created? Default `true`.
  - `private_dns_resolver` - (Optional) Should the private DNS resolver be created? Default `true`.
  - `sidecar_virtual_network` - (Optional) Should the sidecar virtual network be created? Default `true`.
- `default_hub_address_space` - (Optional) The default address space to use if not specified in the hub. This defaults to `10.0.0.0/16` and increments to the next /16 for each region if not supplied.
- `default_parent_id` - (Optional) The default parent resource group ID to use if not specified in hub or individual sections.
- `location` - (Required) The Azure location where the Virtual WAN hub resources should be created.
- `hub` - (Optional) An object defining the Virtual WAN hub settings.
- `virtual_network_connections` - (Optional) A map of Virtual Network connections to create.
- `express_route_circuit_connections` - (Optional) A map of ExpressRoute circuit connections
- `p2s_gateway_vpn_server_configurations` - (Optional) A map of Point-to-Site VPN server configurations.
- `p2s_gateways` - (Optional) A map of Point-to-Site
- `routing_intents` - (Optional) A map of routing intents to create.
- `vpn_site_connections` - (Optional) A map of VPN site connections to create.
- `vpn_sites` - (Optional) A map of VPN sites to create.
- `sidecar_virtual_network` - (Optional) An object defining the sidecar virtual network settings.
- `firewall` - (Optional) An object defining the Azure Firewall settings.
- `firewall_policy` - (Optional) An object defining the Azure Firewall Policy settings.
- `bastion` - (Optional) An object defining the Azure Bastion settings.
- `virtual_network_gateways` - (Optional) An object defining the virtual network gateway settings.
- `private_dns_zones` - (Optional) An object defining the private DNS zones settings.
- `private_dns_resolver` - (Optional) An object defining the private DNS resolver settings

## Virtual Hub

- `hub` - (Optional) An object defining the Virtual WAN hub settings. The object has the following fields:
  - `name` - (Optional) The name of the Virtual Hub.
  - `address_prefix` - (Optional) The address prefix for the Virtual Hub in CIDR format, e.g. `"10.0.0.0/23"`.
  - `parent_id` - (Optional) The ID of the parent resource group where the Virtual Hub should be created.
  - `sku` - (Optional) The SKU of the Virtual Hub. Possible values are `Basic`, `Standard`. Default `null`.
  - `hub_routing_preference` - (Optional) The routing preference for the Virtual Hub. Possible values are `ExpressRoute`, `VpnGateway`, `ASPath`. Default `ExpressRoute`.
  - `virtual_router_auto_scale_min_capacity` - (Optional) The minimum number of scale units for the Virtual Hub router. Default `2`.
  - `tags` - (Optional) A map of tags to apply to the Virtual Hub.

## Virtual Network Connections

- `virtual_network_connections` - (Optional) A map of Virtual Network connections to create. Each connection is an object with the following fields:
  - `name` - (Required) The name of the Virtual Network connection.
  - `remote_virtual_network_id` - (Required) The ID of the remote Virtual Network to connect.
  - `internet_security_enabled` - (Optional) Should internet security be enabled for this connection?
  - `routing` - (Optional) An object with the following fields:
    - `associated_route_table_id` - (Optional) The ID of the route table to associate with this connection.
    - `associated_route_table_key` - (Optional) The key of the route table to associate with this connection.
    - `propagated_route_table` - (Optional) An object with the following fields:
      - `route_table_ids` - (Optional) A list of route table IDs to propagate routes to.
      - `route_table_keys` - (Optional) A list of route table keys to propagate routes to.
      - `labels` - (Optional) A list of labels for route propagation.
    - `inbound_route_map_id` - (Optional) The ID of the inbound route map.
    - `outbound_route_map_id` - (Optional) The ID of the outbound route map.

## ExpressRoute Circuit Connections

- `express_route_circuit_connections` - (Optional) A map of ExpressRoute circuit connections to create. Each connection is an object with the following fields:
  - `name` - (Required) The name of the ExpressRoute circuit connection.
  - `express_route_circuit_peering_id` - (Required) The ID of the ExpressRoute circuit peering.
  - `authorization_key` - (Optional) The authorization key for the ExpressRoute circuit.
  - `enable_internet_security` - (Optional) Should internet security be enabled for this connection?
  - `express_route_gateway_bypass_enabled` - (Optional) Should ExpressRoute gateway bypass be enabled?
  - `routing` - (Optional) An object with the same fields as virtual_network_connections routing.
  - `routing_weight` - (Optional) The routing weight for the connection.

## Point-to-Site Gateway VPN Server Configurations

- `p2s_gateway_vpn_server_configurations` - (Optional) A map of Point-to-Site VPN server configurations. Each configuration is an object with the following fields:
  - `name` - (Required) The name of the VPN server configuration.
  - `vpn_authentication_types` - (Required) A list of VPN authentication types. Possible values are `AAD`, `Certificate`, `Radius`.
  - `tags` - (Optional) A map of tags to apply to the VPN server configuration.
  - `client_root_certificate` - (Optional) An object with the following fields:
    - `name` - (Required) The name of the root certificate.
    - `public_cert_data` - (Required) The public certificate data.
  - `azure_active_directory_authentication` - (Optional) An object with the following fields:
    - `audience` - (Required) The Azure AD audience.
    - `issuer` - (Required) The Azure AD issuer.
    - `tenant` - (Required) The Azure AD tenant.

## Point-to-Site Gateways

- `p2s_gateways` - (Optional) A map of Point-to-Site gateways. Each gateway is an object with the following fields:
  - `name` - (Required) The name of the P2S gateway.
  - `tags` - (Optional) A map of tags to apply to the P2S gateway.
  - `dns_servers` - (Optional) A list of DNS server IP addresses.
  - `p2s_gateway_vpn_server_configuration_key` - (Required) The key of the VPN server configuration to use.
  - `connection_configuration` - (Required) An object with the following fields:
    - `name` - (Required) The name of the connection configuration.
    - `vpn_client_address_pool` - (Required) An object with the following fields:
      - `address_prefixes` - (Required) A list of address prefixes for the VPN client address pool.
  - `scale_unit` - (Required) The scale unit for the P2S gateway.

## Routing Intents

- `routing_intents` - (Optional) A map of routing intents. Each routing intent is an object with the following fields:
  - `name` - (Required) The name of the routing intent.
  - `routing_policies` - (Required) A list of routing policies. Each policy is an object with the following fields:
    - `name` - (Required) The name of the routing policy.
    - `destinations` - (Required) A list of destinations for the routing policy.
    - `next_hop_firewall_key` - (Required) The key of the firewall to use as the next hop.

## VPN Site Connections

- `vpn_site_connections` - (Optional) A map of VPN site connections. Each connection is an object with the following fields:
  - `name` - (Required) The name of the VPN site connection.
  - `remote_vpn_site_key` - (Required) The key of the remote VPN site.
  - `vpn_links` - (Required) A list of VPN links. Each link is an object with the following fields:
    - `name` - (Required) The name of the VPN link.
    - `egress_nat_rule_ids` - (Optional) A list of egress NAT rule IDs.
    - `ingress_nat_rule_ids` - (Optional) A list of ingress NAT rule IDs.
    - `vpn_site_link_number` - (Required) The VPN site link number.
    - `vpn_site_key` - (Required) The key of the VPN site.
    - `bandwidth_mbps` - (Optional) The bandwidth in Mbps.
    - `bgp_enabled` - (Optional) Should BGP be enabled?
    - `connection_mode` - (Optional) The connection mode. Possible values are `Default`, `InitiatorOnly`, `ResponderOnly`. Default `Default`.
    - `ipsec_policy` - (Optional) An object with the following fields:
      - `dh_group` - (Required) The Diffie-Hellman group.
      - `ike_encryption_algorithm` - (Required) The IKE encryption algorithm.
      - `ike_integrity_algorithm` - (Required) The IKE integrity algorithm.
      - `encryption_algorithm` - (Required) The encryption algorithm.
      - `integrity_algorithm` - (Required) The integrity algorithm.
      - `pfs_group` - (Required) The Perfect Forward Secrecy group.
      - `sa_data_size_kb` - (Required) The SA data size in KB.
      - `sa_lifetime_sec` - (Required) The SA lifetime in seconds.
    - `protocol` - (Optional) The protocol. Possible values are `IKEv1`, `IKEv2`. Default `IKEv2`.
    - `ratelimit_enabled` - (Optional) Should rate limiting be enabled? Default `false`.
    - `route_weight` - (Optional) The route weight.
    - `shared_key` - (Optional) The shared key for the VPN connection.
    - `local_azure_ip_address_enabled` - (Optional) Should local Azure IP address be enabled?
    - `policy_based_traffic_selector_enabled` - (Optional) Should policy-based traffic selectors be enabled?
    - `custom_bgp_addresses` - (Optional) A list of custom BGP addresses. Each address is an object with the following fields:
      - `ip_address` - (Required) The IP address.
      - `instance` - (Required) The instance number.
  - `internet_security_enabled` - (Optional) Should internet security be enabled?
  - `routing` - (Optional) An object with the following fields:
    - `associated_route_table` - (Required) The associated route table.
    - `propagated_route_table` - (Optional) An object with the following fields:
      - `route_table_ids` - (Optional) A list of route table IDs.
      - `labels` - (Optional) A list of labels.
    - `inbound_route_map_id` - (Optional) The inbound route map ID.
    - `outbound_route_map_id` - (Optional) The outbound route map ID.
  - `traffic_selector_policy` - (Optional) An object with the following fields:
    - `local_address_ranges` - (Required) A list of local address ranges.
    - `remote_address_ranges` - (Required) A list of remote address ranges.

## VPN Sites

- `vpn_sites` - (Optional) A map of VPN sites. Each site is an object with the following fields:
  - `name` - (Required) The name of the VPN site.
  - `links` - (Required) A list of VPN site links. Each link is an object with the following fields:
    - `name` - (Required) The name of the link.
    - `bgp` - (Optional) An object with the following fields:
      - `asn` - (Required) The BGP ASN.
      - `peering_address` - (Required) The BGP peering address.
    - `fqdn` - (Optional) The FQDN of the VPN site link.
    - `ip_address` - (Optional) The IP address of the VPN site link.
    - `provider_name` - (Optional) The provider name.
    - `speed_in_mbps` - (Optional) The speed in Mbps.
  - `address_cidrs` - (Optional) A list of address CIDRs for the VPN site.
  - `device_model` - (Optional) The device model.
  - `device_vendor` - (Optional) The device vendor.
  - `o365_policy` - (Optional) An object with the following fields:
    - `traffic_category` - (Required) An object with the following fields:
      - `allow_endpoint_enabled` - (Optional) Should allow endpoint be enabled?
      - `default_endpoint_enabled` - (Optional) Should default endpoint be enabled?
      - `optimize_endpoint_enabled` - (Optional) Should optimize endpoint be enabled?
  - `tags` - (Optional) A map of tags to apply to the VPN site.

## Sidecar Virtual Network

- `sidecar_virtual_network` - (Optional) An object defining a sidecar virtual network that can be connected to the Virtual Hub. The object has the following fields:
  - `name` - (Optional) The name of the sidecar virtual network.
  - `parent_id` - (Optional) The ID of the parent resource group where the sidecar virtual network should be created.
  - `address_space` - (Optional) A list of IPv4 address spaces for the sidecar virtual network in CIDR format.
  - `tags` - (Optional) A map of tags to apply to the sidecar virtual network.
  - `ddos_protection_plan` - (Optional) An object with the following fields:
    - `id` - (Required) The ID of the DDoS protection plan.
    - `enable` - (Required) Should DDoS protection be enabled?
  - `virtual_network_connection_settings` - (Optional) An object with the following fields:
    - `name` - (Optional) The name of the virtual network connection.
    - `internet_security_enabled` - (Optional) Should internet security be enabled?
    - `routing` - (Optional) An object with the same fields as virtual_network_connections routing.
  - `subnets` - (Optional) A map of subnets to create in the sidecar virtual network. Each subnet is an object with the following fields:
    - `name` - (Required) The name of the subnet.
    - `address_prefixes` - (Required) The IPv4 address prefixes for the subnet in CIDR format.
    - `nat_gateway` - (Optional) An object with the following fields:
      - `id` - (Required) The ID of the NAT Gateway.
    - `network_security_group` - (Optional) An object with the following fields:
      - `id` - (Required) The ID of the Network Security Group.
    - `private_endpoint_network_policies_enabled` - (Optional) Enable or disable network policies for private endpoints. Default `true`.
    - `private_link_service_network_policies_enabled` - (Optional) Enable or disable network policies for private link services. Default `true`.
    - `route_table` - (Optional) An object with the following fields:
      - `id` - (Optional) The ID of an external Route Table.
      - `assign_generated_route_table` - (Optional) Should the generated route table be assigned? Default `true`.
    - `service_endpoints` - (Optional) A set of service endpoints.
    - `service_endpoint_policy_ids` - (Optional) A set of service endpoint policy IDs.
    - `delegations` - (Optional) A list of subnet delegations. Each delegation is an object with the following fields:
      - `name` - (Required) The name of the delegation.
      - `service_delegation` - (Required) An object with the following fields:
        - `name` - (Required) The name of the service delegation.
        - `actions` - (Optional) A list of actions for the delegation.
    - `default_outbound_access_enabled` - (Optional) Should default outbound access be enabled? Default `false`.

## Azure Firewall

- `firewall` - (Optional) An object defining the Azure Firewall settings for the Virtual Hub. The object has the following fields:
  - `name` - (Optional) The name of the Azure Firewall resource.
  - `sku_name` - (Optional) The SKU name for the Azure Firewall. Possible values are `AZFW_Hub`, `AZFW_VNet`. Default `AZFW_Hub`.
  - `sku_tier` - (Optional) The SKU tier for the Azure Firewall. Possible values are `Basic`, `Standard`, `Premium`. Default `Standard`.
  - `zones` - (Optional) A list of availability zones for the Azure Firewall.
  - `firewall_policy_id` - (Optional) The resource ID of the Azure Firewall Policy to associate with the firewall.
  - `vhub_public_ip_count` - (Optional) The number of public IP addresses to assign to the Virtual Hub firewall.
  - `tags` - (Optional) A map of tags to apply to the Azure Firewall.

## Azure Firewall Policy

- `firewall_policy` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the firewall policy. If not specified will use `afw-policy-{vnetname}`.
  - `resource_group_name` - (Optional) The name of the resource group where the firewall policy should be created. If not specified will use the parent resource group of the virtual network.
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

- `bastion` - (Optional) An object defining Azure Bastion settings for the sidecar virtual network. The object has the following fields:
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Azure Bastion subnet in CIDR format. Must be named `AzureBastionSubnet`.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Azure Bastion subnet? Default `false`.
  - `name` - (Optional) The name of the Azure Bastion resource.
  - `copy_paste_enabled` - (Optional) Should copy-paste be enabled for Azure Bastion? Default `false`.
  - `file_copy_enabled` - (Optional) Should file copy be enabled for Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `ip_connect_enabled` - (Optional) Should IP connect be enabled for Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `kerberos_enabled` - (Optional) Should Kerberos authentication be enabled for Azure Bastion? Default `false`.
  - `scale_units` - (Optional) The number of scale units for Azure Bastion. Valid values are between 2 and 50. Default `2`.
  - `shareable_link_enabled` - (Optional) Should shareable links be enabled for Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `sku` - (Optional) The SKU of Azure Bastion. Possible values are `Basic`, `Standard`. Default `Standard`.
  - `tags` - (Optional) A map of tags to apply to Azure Bastion.
  - `tunneling_enabled` - (Optional) Should tunneling be enabled for Azure Bastion? Requires `Standard` SKU. Default `false`.
  - `zones` - (Optional) A set of availability zones for Azure Bastion.
  - `resource_group_name` - (Optional) The name of the resource group where the Azure Bastion should be created. If not specified, uses the sidecar virtual network's parent resource group.
  - `bastion_public_ip` - (Optional) An object with the following fields:
    - `name` - (Optional) The name of the public IP for Azure Bastion.
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
    - `resource_group_name` - (Optional) The name of the resource group where the Bastion public IP should be created. If not specified, uses the sidecar virtual network's parent resource group.

## Virtual Network Gateways

- `virtual_network_gateways` - (Optional) An object defining Virtual Network Gateway settings for the sidecar virtual network. The object has the following fields:
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the Gateway subnet in CIDR format. Must be named `GatewaySubnet`.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the Gateway subnet? Default `false`.
  - `route_table_creation_enabled` - (Optional) Should a route table be created for the Gateway subnet? Default `false`.
  - `route_table_name` - (Optional) The name of the route table for the Gateway subnet.
  - `route_table_bgp_route_propagation_enabled` - (Optional) Should BGP route propagation be enabled for the Gateway subnet route table? Default `false`.

### ExpressRoute Gateway

- `express_route` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the ExpressRoute gateway.
  - `allow_non_virtual_wan_traffic` - (Optional) Should non-Virtual WAN traffic be allowed? Default `false`.
  - `scale_units` - (Optional) The number of scale units for the ExpressRoute gateway. Default `1`.
  - `tags` - (Optional) A map of tags to apply to the ExpressRoute gateway.

### VPN Gateway

- `vpn` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the VPN gateway.
  - `bgp_route_translation_for_nat_enabled` - (Optional) Should BGP route translation for NAT be enabled?
  - `bgp_settings` - (Optional) An object with the following fields:
    - `instance_0_bgp_peering_address` - (Optional) An object with the following fields:
      - `custom_ips` - (Required) A list of custom IP addresses for instance 0.
    - `instance_1_bgp_peering_address` - (Optional) An object with the following fields:
      - `custom_ips` - (Required) A list of custom IP addresses for instance 1.
    - `peer_weight` - (Required) The peer weight.
    - `asn` - (Required) The BGP ASN.
  - `routing_preference` - (Optional) The routing preference.
  - `scale_unit` - (Optional) The number of scale units for the VPN gateway.
  - `tags` - (Optional) A map of tags to apply to the VPN gateway.

## Private DNS Zones

- `private_dns_zones` - (Optional) An object with the following fields:
  - `parent_id` - (Optional) The ID of the parent resource group where the private DNS zones should be created. If not specified, uses the hub virtual network's parent resource group.
  - `auto_registration_zone_enabled` - (Optional) Should an auto-registration zone be created? Default `true`.
  - `auto_registration_zone_name` - (Optional) The name of the auto-registration zone.
  - `auto_registration_zone_parent_id` - (Optional) The resource group ID for the auto-registration zone.
  - `private_link_excluded_zones` - (Optional) A set of private link zones to exclude from creation. Default `[]`.
  - `private_link_private_dns_zones` - (Optional) A map of private link DNS zones. Each zone is an object with:
    - `zone_name` - (Optional) The DNS zone name.
    - `private_dns_zone_supports_private_link` - (Optional) Does this zone support private link? Default `true`.
    - `resolution_policy` - (Optional) The resolution policy for the DNS zone.
    - `custom_iterator` - (Optional) An object with the following fields:
      - `replacement_placeholder` - The placeholder string to replace (required).
      - `replacement_values` - A map of replacement values (required).
  - `private_link_private_dns_zones_additional` - (Optional) A map of additional private link DNS zones. Same structure as `private_link_private_dns_zones`.
  - `private_link_private_dns_zones_regex_filter` - (Optional) An object with the following fields:
    - `enabled` - (Optional) Should regex filtering be enabled? Default `false`.
    - `regex_filter` - (Optional) The regex filter pattern. Default `{regionName}|{regionCode}`.
  - `virtual_network_link_default_virtual_networks` - (Optional) A map of default virtual network links. Each link is an object with:
    - `virtual_network_resource_id` - (Optional) The virtual network resource ID.
    - `virtual_network_link_name_template_override` - (Optional) Override template for the virtual network link name.
    - `resolution_policy` - (Optional) The resolution policy for the link.
  - `virtual_network_link_additional_virtual_networks` - (Optional) A map of additional virtual network links. Each link is an object with:
    - `virtual_network_resource_id` - (Optional) The virtual network resource ID.
    - `virtual_network_link_name_template_override` - (Optional) Override template for the virtual network link name.
    - `resolution_policy` - (Optional) The resolution policy for the link.
  - `virtual_network_link_by_zone_and_virtual_network` - (Optional) A map of virtual network links by zone and virtual network. Each link is an object with:
    - `virtual_network_resource_id` - (Optional) The virtual network resource ID.
    - `name` - (Optional) The link name.
    - `resolution_policy` - (Optional) The resolution policy for the link.
  - `virtual_network_link_overrides_by_zone` - (Optional) A map of virtual network link overrides by zone. Each override is an object with:
    - `virtual_network_link_name_template_override` - (Optional) Override template for the virtual network link name.
    - `resolution_policy` - (Optional) The resolution policy.
    - `enabled` - (Optional) Should the link be enabled? Default `true`.
  - `virtual_network_link_overrides_by_virtual_network` - (Optional) A map of virtual network link overrides by virtual network. Each override is an object with:
    - `virtual_network_link_name_template_override` - (Optional) Override template for the virtual network link name.
    - `resolution_policy` - (Optional) The resolution policy.
    - `enabled` - (Optional) Should the link be enabled? Default `true`.
  - `virtual_network_link_overrides_by_zone_and_virtual_network` - (Optional) A map of virtual network link overrides by zone and virtual network. Each override is an object with:
    - `name` - (Optional) The link name.
    - `resolution_policy` - (Optional) The resolution policy.
    - `enabled` - (Optional) Should the link be enabled? Default `true`.
  - `virtual_network_link_name_template` - (Optional) The template for naming private DNS zone virtual network links.
  - `virtual_network_link_resolution_policy_default` - (Optional) The default resolution policy for virtual network links.
  - `tags` - (Optional) A map of tags to apply to the private DNS zones.

## Private DNS Resolver

- `private_dns_resolver` - (Optional) An object with the following fields:
  - `name` - (Optional) The name of the DNS resolver.
  - `resource_group_name` - (Optional) The name of the resource group where the DNS resolver should be created. If not specified, uses the hub virtual network's parent resource group.
  - `subnet_address_prefix` - (Optional) The IPv4 address prefix to use for the DNS resolver subnet in CIDR format. Must be a part of the virtual network's address space.
  - `subnet_name` - (Optional) The name of the DNS resolver subnet. Default `dns-resolver`.
  - `subnet_default_outbound_access_enabled` - (Optional) Should the default outbound access be enabled for the DNS resolver subnet? Default `false`.
  - `default_inbound_endpoint_enabled` - (Optional) Should a default inbound endpoint be created? Default `true`.
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

variable "virtual_wan_settings" {
  type = object({
    enabled_resources = optional(object({
      ddos_protection_plan = optional(any, true)
    }), {})
    virtual_wan = optional(object({
      name                              = optional(string)
      location                          = optional(string)
      resource_group_name               = optional(string)
      type                              = optional(string, "Standard")
      allow_branch_to_branch_traffic    = optional(bool, null)
      disable_vpn_encryption            = optional(bool, false)
      office365_local_breakout_category = optional(string, "None")
      tags                              = optional(map(string), null)
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

## Virtual WAN

- `virtual_wan` - (Optional) An object defining the Virtual WAN settings. The object has the following fields:
  - `name` - (Optional) The name of the Virtual WAN resource.
  - `location` - (Optional) The Azure location where the Virtual WAN should be created.
  - `resource_group_name` - (Optional) The name of the resource group where the Virtual WAN should be created.
  - `type` - (Optional) The type of the Virtual WAN. Possible values are `Basic`, `Standard`. Default `Standard`.
  - `allow_branch_to_branch_traffic` - (Optional) Should branch to branch traffic be allowed? Default `null`.
  - `disable_vpn_encryption` - (Optional) Should VPN encryption be disabled? Default `false`.
  - `office365_local_breakout_category` - (Optional) The Office 365 local breakout category. Possible values are `None`, `Optimize`, `OptimizeAndAllow`, `All`. Default `None`.
  - `tags` - (Optional) A map of tags to apply to the Virtual WAN resource.

## DDoS Protection Plan

- `ddos_protection_plan` - (Optional) An object defining the DDoS protection plan settings. When configured, this DDoS protection plan can be associated with hub virtual networks. The object has the following fields:
  - `name` - (Optional) The name of the DDoS protection plan resource.
  - `location` - (Optional) The Azure location where the DDoS protection plan should be created. This should typically match the location of the hub networks that will use it.
  - `resource_group_name` - (Optional) The name of the resource group where the DDoS protection plan should be created.
  - `tags` - (Optional) A map of tags to apply to the DDoS protection plan resource.

DESCRIPTION
}
