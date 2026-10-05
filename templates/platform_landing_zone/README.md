# Azure Landing Zones Accelerator Starter Module for Terraform - Azure Verified Modules Complete Multi-Region

This module is part of the Azure Landing Zones Accelerator solution. It is a complete multi-region implementation of the Azure Landing Zones Platform Landing Zone for Terraform.

It deploys a hub and spoke virtual network or Virtual WAN architecture across multiple regions.

The module deploys the following resources:

- Management group hierarchy
- Azure Policy definitions and assignments
- Role definitions
- Management resources, including Log Analytics workspace and Automation account
- Hub and spoke virtual network or Virtual WAN architecture across multiple regions
- DDOS protection plan
- Private DNS zones

## Usage

The module is intended to be used with the [Azure Landing Zones Accelerator](https://aka.ms/alz/acc). Head over there to get started.

>NOTE: The module can be used independently if needed. Example `tfvars` files can be found in the `examples` directory for that use case.

### Running Directly

#### Run the local examples

Create a `terraform.tfvars` file in the root of the module directory with the following content, replacing the placeholders with the actual values:

```hcl
starter_locations            = ["uksouth", "ukwest"]
subscription_id_connectivity = "00000000-0000-0000-0000-000000000000"
subscription_id_identity     = "00000000-0000-0000-0000-000000000000"
subscription_id_management   = "00000000-0000-0000-0000-000000000000"
```

##### Hub and Spoke Virtual Networks Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/full-multi-region/hub-and-spoke-vnet.tfvars
```

##### Virtual WAN Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/full-multi-region/virtual-wan.tfvars
```

### Virtual WAN module v0.18.0 inputs

The template pins the Virtual WAN pattern to `0.18.0` and exposes its newer inputs:

- `virtual_hubs[hub_key].is_primary` selects the primary region used for default Virtual WAN, DDoS Protection Plan, and private DNS zone locations. Only one hub may be primary. If none is marked, the first hub key alphabetically is selected; the default is `false`.
- `virtual_hubs[hub_key].vpn_site_connections[connection_key].vpn_links[*].dpd_timeout_seconds` sets the VPN link's dead peer detection timeout in seconds (9–3600).
- `ignore_body_changes` configures shared ignored body paths for secured hub firewalls, firewall diagnostic settings, route maps, sidecar virtual networks, and sidecar subnets. Per-subnet `ignore_body_changes` takes precedence over the shared subnet paths. Leave the matching dedicated input unset for ignored paths. These paths are write-only provider state, take effect after `apply`, and non-empty lists require Terraform 1.11 or later.

### Customer-owned public IPs for secured Virtual WAN hubs

Configure `virtual_hubs[hub_key].firewall.ip_configurations[stable_key]` to attach caller-owned public IPs. Each entry requires `name` and `public_ip_address_id`. Use stable keys known at plan time; the public IP resource ID itself may be unknown until apply.

| Customer IP map | `vhub_public_ip_count` | Mode |
| --- | --- | --- |
| Empty or omitted | Omitted or `null` | Existing managed-IP default, unchanged |
| Empty | Positive integer as a string | Managed IPs with that count |
| Nonempty | Omitted, `null`, or `"0"` | Customer-owned IPs only |
| Nonempty | Positive count | Invalid; customer and managed IPs cannot be combined |

The public IPs must meet the [secured hub prerequisites](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip): Standard SKU, Regional tier, static IPv4, the same subscription as the firewall, and the hub's region. They must be unassociated or already attached to this firewall. Configuration names and public IP IDs must be unique ignoring case. The firewall must use the `Standard` or `Premium` SKU tier. The firewall attaches these IPs but does not create or own their lifecycle.

Literal IDs and the Accelerator's built-in/custom replacements are supported. Resource expressions cannot be used in `.tfvars`; for an IP created in the same apply, pass its ID directly in an HCL module call. The template preserves apply-time IDs separately from whole-hub JSON templating so unknown IDs do not make hub or configuration keys unknown. `templated_inputs` includes the resolved IDs.

Customer IPs can be used when creating a firewall and can be added, removed, or replaced on a firewall already in customer mode. Plan such changes as maintenance; they are not guaranteed to be outage-free. Converting an existing firewall between managed and customer IP modes, including removing its last customer IP, is not supported. Keep an existing managed firewall in managed mode when upgrading.
