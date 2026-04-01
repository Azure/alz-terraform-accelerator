# Platform landing zone - Full multi-region example

This example configuration deploys a full multi-region landing zone with:

- Management Groups
- Policy
- Management Resources
- Hub Networking (with Hub and Spoke VNet or vWAN)
- Private DNS Zones for Private Link
- DDOS Protection Plan
- Azure Firewall

## Options

There are two options for deploying the hub networking, each available in a full and minimal configuration:

- Hub and Spoke VNet: [hub-and-spoke-vnet.tfvars](./hub-and-spoke-vnet.tfvars)
- Hub and Spoke VNet (minimal): [hub-and-spoke-vnet-minimal.tfvars](./hub-and-spoke-vnet-minimal.tfvars)
- Virtual WAN: [virtual-wan.tfvars](./virtual-wan.tfvars)
- Virtual WAN (minimal): [virtual-wan-minimal.tfvars](./virtual-wan-minimal.tfvars)

The minimal configurations use `default_hub_address_space` and rely on module defaults for resource names and subnet CIDRs, resulting in a simpler configuration.

## Documentation

The full documentation for this example can be found over at out [Azure Landing Zones documentation site](https://azure.github.io/Azure-Landing-Zones/accelerator/startermodules/terraform-platform-landing-zone/scenarios/).
