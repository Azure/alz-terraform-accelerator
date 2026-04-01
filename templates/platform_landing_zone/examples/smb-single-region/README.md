# Platform landing zone - SMB single-region example

This example configuration is designed for small-medium businesses starting out with Azure Landing Zones. It deploys a cost-optimized single-region landing zone with:

- Management Groups
- Policy
- Management Resources
- Hub Networking (with Hub and Spoke VNet or vWAN)
- Private DNS Zones for Private Link
- Azure Firewall (Basic SKU)
- VPN Gateway

The following resources are **disabled** to reduce cost:

- DDoS Protection Plan
- ExpressRoute Gateway
- Azure Bastion

> **WARNING — DDoS Protection:**
> This example disables the DDoS Protection Plan to reduce cost. This removes network-level DDoS protection from all virtual networks. To maintain security, you **MUST** enable [DDoS IP Protection](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison) on each public IP address individually. Failure to do so leaves your workloads exposed to DDoS attacks.

Subscription placement for **identity** and **security** subscriptions is commented out but retained in the configuration for when you are ready to add dedicated subscriptions for those workloads.

## Options

There are two options for deploying the hub networking:

- Hub and Spoke VNet: [hub-and-spoke-vnet.tfvars](./hub-and-spoke-vnet.tfvars)
- Virtual WAN: [virtual-wan.tfvars](./virtual-wan.tfvars)

## Documentation

The full documentation for this example can be found over at out [Azure Landing Zones documentation site](https://azure.github.io/Azure-Landing-Zones/accelerator/startermodules/terraform-platform-landing-zone/scenarios/).
