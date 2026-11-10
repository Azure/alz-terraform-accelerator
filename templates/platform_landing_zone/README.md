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

### Hub and spoke virtual network module v0.18.1 inputs

The template pins the hub and spoke virtual network pattern to `0.18.1`, which
requires `Azure/azapi` `2.12` or later. Run `terraform init -upgrade` after
upgrading. The template exposes the module's newer inputs:

- `hub_virtual_networks[hub_key].is_primary` marks the primary hub, which
  supplies the default location, name, and resource group of the DDoS
  Protection Plan and is the only hub whose private link private DNS zones are
  not filtered by default. Only one hub may be primary. If none is marked, the
  first hub key alphabetically is selected; the default is `false`.
- `hub_virtual_networks[hub_key].dns_resolver_policy` deploys an Azure DNS
  Security Policy linked to the hub virtual network, with optional domain
  lists, security rules, and additional virtual network links. No policy is
  created unless the object is set. `enabled_resources.dns_resolver_policy`
  (default `true`) turns it off without removing the object.
- `lock` on `hub_virtual_network`, `firewall`, `firewall_policy`,
  `virtual_network_gateways.express_route`, `virtual_network_gateways.vpn`,
  `private_dns_resolver`, `private_dns_zones`, and `dns_resolver_policy` adds a
  management lock. The private DNS zones lock is applied to their resource group.
- `public_ip_config.ip_tags` on the firewall's `default_ip_configuration`,
  `ip_configurations`, and `management_ip_configuration` sets IP tags on the
  firewall public IPs.
- `hub_virtual_network.route_table_user_subnets_bgp_propagation_enabled` turns
  off BGP route propagation on the user subnet route table.
- `hub_virtual_network.subnets[subnet_key].service_endpoints` replaces the
  deprecated `service_endpoints_with_location`, whose `locations` are ignored.
  Set one or the other, not both.
- `hub_virtual_network.subnets[subnet_key].ignore_body_changes` and the shared
  `ignore_body_changes` input (`virtual_networks`, `virtual_networks_subnets`,
  and `virtual_networks_virtual_network_peerings`) stop the `azapi` provider
  reconciling the listed body paths, so Azure Virtual Network Manager or Azure
  Policy can own them. A per-subnet value other than `null`, including an empty
  list, replaces the shared subnet paths. Non-empty lists require Terraform
  1.11 or later.
- `bastion.sku` accepts `Premium`, which enables `bastion.private_only_enabled`
  (no public IP) and `bastion.session_recording_enabled`. `bastion.parent_id`
  places the Bastion host in another resource group; `bastion.resource_group_name`
  remains a deprecated fallback.
- `bastion.copy_paste_enabled` keeps the template default of `false`, although
  the module's own default is now `true`. Disabling copy and paste requires the
  `Standard` or `Premium` SKU, so set it to `true` for the `Basic` SKU.

When upgrading an existing deployment, expect in-place updates to hub virtual
networks, subnets, peerings, and virtual network gateways from the module's new
retry defaults and explicit empty subnet service endpoint lists. No resource
should be replaced. If the plan replaces a resource because its `zones` change,
see [Availability zones when upgrading](#availability-zones-when-upgrading).

### Availability zones when upgrading

Up to version `0.17.3`, the hub and spoke virtual network module read the
availability zones of each hub's region from your subscription. From `0.17.4`,
it uses the region data cached in the `Azure/avm-utl-regions` module instead.
Logical zones are assigned per subscription, so the two can differ. For
example, a subscription can report four zones in `eastus2` while the cached
data lists three.

Where they differ, upgrading from `0.17.3` or earlier changes the default zones
of the hub's zonal resources, which Azure can't change in place. The plan shows
`# forces replacement` for Azure Firewall and for the public IP addresses of the
firewall, Bastion host, and virtual network gateways. Replacing Azure Firewall
deletes it and its public IP addresses, which interrupts traffic and changes
the addresses. A public IP address that is still attached to a Bastion host or
virtual network gateway can't be deleted, so the apply fails part-way.

Before you apply the upgrade, check the plan for changes to `zones`. If there
are any, set the zones of the affected hub to the zones that are deployed, then
plan again. These settings default to the region's zones:

- `firewall.zones`, and `public_ip_config.zones` in
  `firewall.default_ip_configuration`, `firewall.ip_configurations[<key>]`,
  and `firewall.management_ip_configuration`
- `bastion.zones` and `bastion.bastion_public_ip.zones`
- `public_ip.zones` in
  `virtual_network_gateways.express_route.ip_configurations[<key>]` and
  `virtual_network_gateways.vpn.ip_configurations[<key>]`
- `nat_gateway.zones` and
  `nat_gateway.ip_configurations[<key>].public_ip_configuration.zones`

For example, for a Bastion host and its public IP address deployed in four
zones:

```terraform
bastion = {
  zones = ["1", "2", "3", "4"]
  bastion_public_ip = {
    zones = ["1", "2", "3", "4"]
  }
}
```

Each resource's `zones` property in Azure shows the deployed zones, for example
`az network public-ip show --ids <public_ip_id> --query zones`. Explicit zones
also stay the same if a later module version updates the cached region data.

### Upgrading Azure Bastion

Version `0.18.1` of the hub and spoke virtual network module manages Azure
Bastion with `azapi_resource` instead of `azurerm_bastion_host`, which changes
the Bastion host's address in state. `main.moved.tf` migrates it:

- `moved` blocks move the Bastion hosts of the `primary` and `secondary` hubs,
  the keys used by the examples. The `azapi` provider takes each host's
  resource ID from the existing state, so no input is needed.
- A `removed` block makes Terraform forget, rather than destroy, a Bastion host
  under any other hub key.

If your `hub_virtual_networks` use other keys, add a `moved` block for each key
that has a Bastion host before you plan the upgrade, for example in a new
`bastion.moved.tf` file:

```terraform
moved {
  from = module.hub_and_spoke_vnet[0].module.bastion_host["<hub_key>"].azurerm_bastion_host.this
  to   = module.hub_and_spoke_vnet[0].module.bastion_host["<hub_key>"].azapi_resource.bastion[0]
}
```

Review the plan before applying. Each Bastion host must show as moved, possibly
with an in-place update that keeps the same `zones` (their order can differ).
Stop if a Bastion host will be created, destroyed, replaced, or no longer
managed by Terraform. Apply the upgrade on its own before removing a hub or
disabling its Bastion host, because Terraform does not delete a Bastion host
that it forgets.

If a Bastion host has already been forgotten, the apply fails with `Resource
already exists` and the host keeps running. Import it into its new address,
apply again, and then delete the `import` block:

```terraform
import {
  id = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.Network/bastionHosts/<bastion_name>"
  to = module.hub_and_spoke_vnet[0].module.bastion_host["<hub_key>"].azapi_resource.bastion[0]
}
```

Use the exact ID from the `hub_and_spoke_vnet_bastion_host_resource_ids`
output, because the `azapi` provider replaces the host if its name or resource
group ID differs, including in case. The module's README warns that an import
can plan a replacement because of
[Azure/terraform-provider-azapi#858](https://github.com/Azure/terraform-provider-azapi/issues/858);
that issue is fixed in `azapi` `2.4.0`.

New deployments need no action.

### Virtual WAN module v0.18.0 inputs

The template pins the Virtual WAN pattern to `0.18.0` and exposes its newer inputs:

- `virtual_hubs[hub_key].is_primary` selects the primary region used for default
  Virtual WAN, DDoS Protection Plan, and private DNS zone locations. Only one
  hub may be primary. If none is marked, the first hub key alphabetically is
  selected; the default is `false`.
- `virtual_hubs[hub_key].vpn_site_connections[connection_key].vpn_links[*].dpd_timeout_seconds` sets the VPN link's dead peer detection timeout in seconds (9–3600).
- `ignore_body_changes` configures shared ignored body paths for secured hub
  firewalls, firewall diagnostic settings, route maps, sidecar virtual networks,
  and sidecar subnets. Per-subnet `ignore_body_changes` takes precedence over
  the shared subnet paths. Leave the matching dedicated input unset for ignored
  paths. These paths are write-only provider state, take effect after `apply`,
  and non-empty lists require Terraform 1.11 or later.

### Customer-owned public IPs for secured Virtual WAN hubs

Configure `virtual_hubs[hub_key].firewall.ip_configurations[stable_key]` to attach caller-owned public IPs. Each entry requires `name` and `public_ip_address_id`. Use stable keys known at plan time; the public IP resource ID itself may be unknown until apply.

| Customer IP map | `vhub_public_ip_count` | Mode |
| --- | --- | --- |
| Empty or omitted | Omitted or `null` | Existing managed-IP default, unchanged |
| Empty | Positive integer as a string | Managed IPs with that count |
| Nonempty | Omitted, `null`, or `"0"` | Customer-owned IPs only |
| Nonempty | Positive count | Invalid; customer and managed IPs cannot be combined |

The public IPs must meet the [secured hub prerequisites](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip):
Standard SKU, Regional tier, static IPv4, the same subscription as the firewall,
and the hub's region. They must be unassociated or already attached to this
firewall. Configuration names and public IP IDs must be unique ignoring case.
The firewall must use the `Standard` or `Premium` SKU tier. The firewall
attaches these IPs but does not create or own their lifecycle.

Literal IDs and the Accelerator's built-in/custom replacements are supported.
Resource expressions cannot be used in `.tfvars`; for an IP created in the same
apply, pass its ID directly in an HCL module call. The template preserves
apply-time IDs separately from whole-hub JSON templating so unknown IDs do not
make hub or configuration keys unknown. `templated_inputs` includes the
resolved IDs.

Customer IPs can be used when creating a firewall and can be added, removed, or
replaced on a firewall already in customer mode. Plan such changes as
maintenance; they are not guaranteed to be outage-free. Converting an existing
firewall between managed and customer IP modes, including removing its last
customer IP, is not supported. Keep an existing managed firewall in managed
mode when upgrading.
