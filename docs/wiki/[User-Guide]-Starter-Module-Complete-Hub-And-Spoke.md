# Complete Hub and Spoke Scenario Documentation

The "Complete Hub and Spoke" scenario uses Terraform to fully customize Azure Landing Zone deployment. The scenario emphasizes a hub-and-spoke network topology and includes modules for management groups, connectivity, and security components.

## Recommended Modules

The following modules are key components for the "Complete Hub and Spoke" architecture:

### `caf-enterprise-scale`

The Cloud Adoption Framework's `caf-enterprise-scale` Terraform module sets up a scalable management group hierarchy, policy assignments, and compliance settings.



```hcl
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 5.2.0"
  
  # ...
}

```

### `hubnetworking`

The `hubnetworking` Terraform module creates the hub-and-spoke network topology including the virtual networks and optionally deploys and configures network components like Azure Firewall.



```hcl
module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "~> 1.1.0"
  
  # ...
}

```

### `azurerm_firewall_policy`

This resource creates an Azure Firewall Policy, which enables customization of firewall rules and settings.



```hcl
resource "azurerm_firewall_policy" "this" {
  # ...
}

```

### `azurerm_firewall_policy_rule_collection_group`

Assigns rule collection groups to the firewall policy to control network traffic flow.


```hcl
resource "azurerm_firewall_policy_rule_collection_group" "example" {
  # ...
}

```

### `virtual_network_gateway`

Establishes a Virtual Network Gateway for secure VPN connections and can also be used for ExpressRoute connectivity.



```hcl
module "virtual_network_gateway" {
  # ...
}

```

### Azure Bastion and Jumpbox VM

For secure RDP/SSH access to virtual machines, the Azure Bastion service is provisioned and a separate virtual machine is deployed to function as a jumpbox.



```hcl
module "azure_bastion" {
  # ...
}

module "vmjumpbox" {
  # ...
}

```

## Implementation Overview

-   The central hub is the Azure VNet that acts as the connectivity focal point to which different spokes (VNets) will connect.
-   The `caf-enterprise-scale` module will define and enforce governance, compliance, and management across all VNets.
-   The `hubnetworking` module allows for the configuration of the central hub, including the deployment of Azure Firewall for enhanced security and firewall policies.
-   An Azure Firewall Policy is defined and associated with the Azure Firewall to implement the required rule sets for traffic filtering.
-   A Virtual Network Gateway is configured, enabling VPN or ExpressRoute for communication between Azure and on-premises networks.
-   Azure Bastion provides secure and seamless RDP and SSH connectivity to Azure VMs without public IP addresses, directly through the Azure portal.
-   A Jumpbox VM (Virtual Machine) is deployed to facilitate secure management tasks within the Azure environment.

## Deployment Process

To deploy the "Complete Hub and Spoke" scenario:

1.  Customize the `enterprise_scale` and `hubnetworking` modules in your Terraform files according to your organizational structure and networking requirements.
2.  Define your Azure Firewall policies and rulesets within the `azurerm_firewall_policy` and `azurerm_firewall_policy_rule_collection_group` resources.
3.  Deploy the Virtual Network Gateway, Azure Bastion, and Jumpbox VM as per your connectivity and management access needs.
4.  Apply the Terraform configuration to provision the resources in your Azure environment.

Please consider referencing Terraform and Azure documentation for in-depth guidance on module usage and attribute definitions to ensure the deployment aligns with best practices and your organization's architectural requirements.