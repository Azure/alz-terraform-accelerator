<!-- markdownlint-disable first-line-h1 -->
The `hubnetworking` starter module builds off the `basic` starter module ([Basic Starter Module][wiki_starter_module_basic]) and additionally configures hub networking resources such as the Virtual Network, Firewall and Virtual Network Gateway.

## High Level Design

![Alt text](./media/starter-module-hubnetworking.png)

## Terraform Modules

### `caf-enterprise-scale`

The `caf-enterprise-scale` has been used to deploy the management group hierarchy, policy assignments and management resources. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale).

### `hubnetworking`

The `hubnetworking` module is used to deploy connectivity resources such as Virtual Networks and Firewalls. By default, the module will deploy a Virtual Network with a Firewall in your `default_location`. This module can be extended however to deploy multiple Virtual Networks at scale, Route Tables, and Resource Locks. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-hubnetworking).

### `vnet-gateway`

The `vnet-gateway` module is used to deploy a Virtual Network Gateway inside your Virtual Network. By default, the resources of the module will not be deployed unless `virtual_network_gateway_creation_enabled` is set to true, if so, the module will deploy a VPN Gateway with SKU VpnGw1. Further configuration can be added depending on requirements to deploy Local Network Gateways, configure Virtual Network Gateway Connections, deploy ExpressRoute Gateways and more. Additional information on the module can be found [here](https://github.com/Azure/terraform-azurerm-vnet-gateway).

## Inputs

- `default_location`: The location for Azure resources (e.g 'uksouth').
- `subscription_id_connectivity`: The identifier of the Connectivity Subscription.
- `subscription_id_identity`: The identifier of the Identity Subscription.
- `subscription_id_management`: The identifier of the Management Subscription.
- `root_id`: The root id is the identity for the root management group and a prefix applied to all management group identities.
- `root_name`: The display name for the root management group.
- `hub_virtual_network_address_prefix`: The IP address range for the hub network in CIDR format.
- `firewall_subnet_address_prefix`: The IP address range foe the firewall subnet in CIDR format.
- `gateway_subnet_address_prefix`: The IP address range foe the gateway subnet in CIDR format.
- `virtual_network_gateway_creation_enabled`: Whether the virtual network gateway is created.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_starter_module_basic]:                   %5BUser-Guide%5D-Starter-Module-Basic "Wiki - Starter Modules - Basic"
