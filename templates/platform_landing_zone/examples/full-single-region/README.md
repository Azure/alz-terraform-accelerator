# Platform landing zone - Full single-region example

This example configuration deploys a full single-region landing zone with:

- Management Groups
- Policy
- Management Resources
- Hub Networking (with Hub and Spoke VNet or vWAN)
- Private DNS Zones for Private Link
- DDOS Protection Plan
- Azure Firewall

## Options

There are two options for deploying the hub networking:

- Hub and Spoke VNet: [hub-and-spoke-vnet.tfvars](./hub-and-spoke-vnet.tfvars)
- Virtual WAN: [virtual-wan.tfvars](./virtual-wan.tfvars)

## Documentation

The full documentation for this example can be found over at out [Azure Landing Zones documentation site](https://azure.github.io/Azure-Landing-Zones/accelerator/startermodules/terraform-platform-landing-zone/scenarios/).
