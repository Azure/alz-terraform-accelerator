# Platform landing zone - Full single-region for NVA (Network Virtual Appliance) example

This example configuration deploys a full single-region landing zone ready for NVA support:

- Management Groups
- Policy
- Management Resources
- Hub Networking (with Hub and Spoke VNet or vWAN)
- Private DNS Zones for Private Link
- DDOS Protection Plan

## Options

There are two options for deploying the hub networking:

- Hub and Spoke VNet: [hub-and-spoke-vnet.tfvars](./hub-and-spoke-vnet.tfvars)
- Virtual WAN: [virtual-wan.tfvars](./virtual-wan.tfvars)

## Limitations

The vWAN module does not currently support routes, we'll need to add that per this issue: <https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan/issues/119>

## Documentation

The full documentation for this example can be found over at our [Azure Landing Zones documentation site](https://azure.github.io/Azure-Landing-Zones/accelerator/startermodules/terraform-platform-landing-zone/scenarios/).
