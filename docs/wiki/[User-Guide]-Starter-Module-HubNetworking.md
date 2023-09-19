<!-- markdownlint-disable first-line-h1 -->

The `hubnetworking` starter module creates a management group hierarchy, assigns policies and deploys hub networking resources.

## Inputs

- `default_location`: The location for Azure resources (e.g 'uksouth').
- `subscription_id_connectivity`: The identifier of the Connectivity Subscription.
- `subscription_id_identity`: The identifier of the Identity Subscription.
- `subscription_id_management`: The identifier of the Management Subscription.
- `root_id`: The root id is the identity for the root managment group and a prefix applied to all management group identities.
- `root_name`: The display name for the root management group.
- `hub_virtual_network_address_prefix`: The IP address range for the hub network in CIDR format.
- `firewall_subnet_address_prefix`: The IP address range foe the firewall subnet in CIDR format.
- `gateway_subnet_address_prefix`: The IP address range foe the gatway subnet in CIDR format.
- `virtual_network_gateway_creation_enabled`: Whether the virtual network gateway is created.
