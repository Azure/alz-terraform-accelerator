
# Complete Virtual WAN Deployment Scenario Documentation

The "Complete Virtual WAN (vWAN)" scenario uses Terraform to create a scalable and automated Azure network infrastructure. This sophisticated configuration emphasizes a global transit network strategy that incorporates governance, connectivity, and security elements within a unified managed network service.

## Key Terraform Modules and Resources

### `caf-enterprise-scale`

The `caf-enterprise-scale` module establishes the governance structure for Azure by setting up a management group hierarchy, policy assignments, and ensuring compliance.

```hcl
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 5.2.0"
  
  # ...
}
```

### `hubnetworking`

The `hubnetworking` module configures a shared virtual network which is utilized for centralized services like jumpbox and Azure Bastion.

```hcl
module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "~> 1.1.0"
  
  # ...
}
```

### `vwan`

The `vwan` module implements the Azure Virtual WAN service, facilitating a hub-and-spoke architecture that enables automated routing and global connectivity.

```hcl
module "vwan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "~> 0.5.0"
  
  # ...
}
```

### `azurerm_virtual_hub_connection`

This resource establishes a connection between the virtual hubs within the vWAN and virtual networks, promoting seamless interconnectivity and centralized network management.

```hcl
resource "azurerm_virtual_hub_connection" "example_connection" {
  # ...
}
```

### `azurerm_firewall_policy`

This resource defines a firewall policy for the virtual WAN, offering advanced routing and security settings at a WAN scope.

```hcl
resource "azurerm_firewall_policy" "this" {
  # ...
}
```

### Azure Bastion and Jumpbox VM

Incorporating Azure Bastion within the vWAN infrastructure allows for secure RDP/SSH connectivity across the network without the need for public IP addresses. A separate jumpbox VM is used for secure administrative access.

```hcl
module "azure_bastion" {
  # ...
}

module "vmjumpbox" {
  # ...
}
```

## Virtual WAN vs Traditional Hub and Spoke

The vWAN architecture provides an orchestrated and optimized network connectivity solution compared to traditional hub-and-spoke configurations. Key differences include:

- Centralized routing and security controls across various segments of the network, including branch-to-branch connectivity.
- Global traffic transit with automated routing leveraging the Microsoft Global Network.
- A unified operational model and significantly simplified network management experience.
- Consistent policy and security enforcement across the entire network footprint.

This approach is well-suited for enterprises looking to simplify complex networking scenarios, especially for those requiring robust, global networking capabilities.

## Deployment Procedure

To implement the "Complete vWAN" scenario:

1. Tailor the `enterprise_scale`, `hubnetworking`, and `vwan` modules within your Terraform configurations to reflect your network architecture and requirements.
2. Establish Azure Firewall policies and rules at the WAN-level to maintain security and governance.
3. Setup Azure Bastion for central, secure access to VMs, and configure a jumpbox VM for network management operations.
4. Execute the Terraform plan to provision the defined Azure environment resources.

When deploying, consult the detailed Terraform and Azure documentation for guidance on utilizing these modules and resources, ensuring that the deployment adheres to your organization's network strategy and best practices.