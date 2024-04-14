<!-- markdownlint-disable first-line-h1 -->

## `archetypes`

Specifies the archetypes to be used through the `caf-enterprise-scale` module.

```yaml

archetypes: # Arguments from https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/v4.2.0/variables.tf converted to YAML.
  disable_telemetry: # boolean
  default_location: # string
  root_parent_id: # string
  archetype_config_overrides: # object
  configure_connectivity_resources: # object
  configure_identity_resources: # object
  configure_management_resources: # object
  create_duration_delay: # object
  custom_landing_zones: # object
  custom_policy_roles: # object
  default_tags: # object
  deploy_connectivity_resources: # boolean
  deploy_corp_landing_zones: # boolean
  deploy_core_landing_zones: # boolean
  deploy_demo_landing_zones: # boolean
  deploy_diagnostics_for_mg: # boolean
  deploy_identity_resources: # boolean
  deploy_management_resources: # boolean
  deploy_online_landing_zones: # boolean
  deploy_sap_landing_zones: # boolean
  destroy_duration_delay: # object
  disable_base_module_tags: # boolean
  library_path: # string
  policy_non_compliance_message_default: # string
  policy_non_compliance_message_default_enabled: # boolean
  policy_non_compliance_message_enabled: # boolean
  policy_non_compliance_message_enforced_replacement: # string
  policy_non_compliance_message_enforcement_placeholder: # string
  policy_non_compliance_message_not_enforced_replacement: # string
  policy_non_compliance_message_not_supported_definitions: # list
  resource_custom_timeouts: # object
  root_id: # string
  root_name: # string
  strict_subscription_association: # boolean
  subscription_id_connectivity: # string
  subscription_id_identity: # string
  subscription_id_management: # string
  subscription_id_overrides: # object
  template_file_variables: # string

```

### `archetypes` Example

```yaml

archetypes: # `caf-enterprise-scale` module, add inputs as listed on the module registry where necessary.
  root_name: es
  root_id: Enterprise-Scale
  deploy_corp_landing_zones: true
  deploy_online_landing_zones: true
  default_location: uksouth
  disable_telemetry: true
  deploy_management_resources: true
  default_tags:
    environment: dev
    costcenter: 12345
  configure_management_resources:
    location: uksouth
    settings:
      security_center:
        config:
          email_security_contact: "security_contact@replace_me"
  custom_landing_zones:
    eucustomers:
      display_name: EU Customers
      parent_management_group_id: es-landing-zones

```

## `connectivity`

Specifies the connectivity configuration to be used.

```yaml

connectivity: [ hubnetworking ] # Type of connectivity to be deployed (e.g. hubnetworking or virtual wan.)

```

## `connectivity.hubnetworking`

Specifies the hub networking configuration to be used from the `terraform-azurerm-hubnetworking` module.

```yaml

connectivity:
  hubnetworking: # # Arguments from https://github.com/Azure/terraform-azurerm-hubnetworking/blob/v1.1.1/variables.tf converted to YAML.
    hub_virtual_networks: # object

```

### `connectivity.hubnetworking` Example

```yaml
connectivity:
  hubnetworking:
    hub_virtual_networks:
      hub-one:
        name: vnet-hub
        resource_group_name: rg-connectivity
        location: uksouth
        address_space:
          - 10.0.0.0/16
        firewall:
          name: fw-hub
          sku_name: AZFW_VNet
          sku_tier: Standard
          subnet_address_prefix: 10.0.1.0/24

```

## `connectivity.hubnetworking.hub_virtual_networks.<hub_key>.virtual_network_gateway`

Specifies the virtual network gateway configuration to be used from the `terraform-azurerm-avm-ptn-vnetgateway` module.

```yaml

connectivity:
  hubnetworking:
    hub_virtual_networks:
      <hub_key>:
        name: # string
        resource_group_name: # string
        location: # string
        address_space: # list
        virtual_network_gateway: # Arguments from https://github.com/Azure/terraform-azurerm-avm-ptn-vnetgateway/blob/v0.3.0/variables.tf converted to YAML.
          name: # string
          sku: # string
          subnet_address_prefix: # string
          subnet_creation_enabled: # boolean
          type: # string
          default_tags: # object
          edge_zone: # string
          express_route_circuits: # object
          ip_configurations: # object
          local_network_gateways: # object
          tags: # object
          vpn_active_active_enabled: # boolean
          vpn_bgp_enabled: # boolean
          vpn_bgp_settings: # object
          vpn_generation: # string
          vpn_point_to_site: # object
          vpn_type: # string
          vpn_private_ip_address_enabled: # boolean
          route_table_bgp_route_propagation_enabled: # boolean
          route_table_creation_enabled: # boolean
          route_table_name: # string
          route_table_tags: # object

```

### `connectivity.hubnetworking.hub_virtual_networks.<hub_key>.virtual_network_gateway` Example

```yaml
connectivity:
  hubnetworking:
    hub_virtual_networks:
      hub-one:
        name: vnet-hub
        resource_group_name: rg-connectivity
        location: uksouth
        address_space:
          - 10.0.0.0/16
        firewall:
          name: fw-hub
          sku_name: AZFW_VNet
          sku_tier: Standard
          subnet_address_prefix: 10.0.1.0/24
        virtual_network_gateway:
          name: vgw-hub
          sku: VpnGw1
          type: Vpn
          subnet_address_prefix: 10.0.2.0/24
```

## `connectivity.vwan`

Specifies the hub networking configuration to be used from the `terraform-azurerm-avm-ptn-virtualwan` module.

```yaml

connectivity:
  vwan: # Arguments from https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan/blob/v0.4.0/variables.tf converted to YAML.
    allow_branch_to_branch_traffic: # boolean
    create_resource_group: # boolean
    disable_vpn_encryption: # boolean
    enable_telemetry: # boolean
    er_circuit_connections: # object
    expressroute_gateways: # object
    firewalls: # object
    location: # string
    office365_local_breakout_category
    p2s_gateway_vpn_server_configurations: # object
    p2s_gateways: # object
    resource_group_name: # string
    resource_group_tags: # object
    routing_intents: # object
    telemetry_resource_group_name: # string
    type: # string
    virtual_hubs: # object
    virtual_network_connections: # object
    virtual_wan_name: # string
    virtual_wan_tags: # object
    vpn_gateways: # object
    vpn_site_connections: # object
    vpn_sites: # object
    tags: # object
```

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)
