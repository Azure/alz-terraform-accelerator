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

### Upgrading to ALZ module v0.23.0

The platform and test starters pin the management groups and policy module to
`0.23.0`. Review both the [v0.22.0 release notes](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/releases/tag/v0.22.0)
and [v0.23.0 release notes](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/releases/tag/v0.23.0)
when upgrading from `0.21.0`.

- `management_group_settings.policy_assignments_to_modify[management_group].policy_assignments[assignment].policy_definition_id`
  can reference an externally managed definition. It defaults to `null`, retaining
  the library definition; an empty or whitespace-only string is treated the same way.
  The external definition must exist at or above the assignment scope and accept the
  library assignment's parameters. Changing the definition ID of an existing
  assignment forces replacement: Terraform deletes the assignment and its policy role
  assignments before creating the new one, so an invalid ID leaves the management
  group without that assignment until the plan is corrected. The new assignment gets
  a new system-assigned identity. Its role assignments still come from the library
  definition, not the external one; grant any extra roles the external definition
  needs yourself.
- The same assignment object accepts `role_assignments_enabled`, default `true`.
  Setting it to `false` skips the policy assignment's RBAC grants but retains the
  policy assignment and its managed identity. On an existing deployment, this can
  remove grants, so review the plan before changing it.
- ALZ telemetry no longer sends the custom ModTM payload. Its replacement telemetry
  deployment name has a 64-character limit, and the existing `deployed_by` and
  `correlation_id` metadata would exceed it. As an interim, the starter sends the
  ALZ module only `s = "alz"` and, when set, the last 12 letters and digits of
  `correlation_id` (the last segment of a GUID). Other keys in
  `telemetry_additional_content` are not sent to the ALZ module, and no other module
  in the starter uses the map. Setting it to `null` sends no custom content. A
  replacement telemetry approach is in progress upstream
  ([Azure-Verified-Modules#3112](https://github.com/Azure/Azure-Verified-Modules/issues/3112)).
  Normal ALZ telemetry remains enabled by default; `enable_telemetry = false` still
  opts out for all child modules. With telemetry enabled, ALZ creates a
  subscription-scope deployment in the management subscription, plus one for each
  entry in `management_group_role_assignments`, so the identity running Terraform
  needs `Microsoft.Resources/deployments/write` there.
- The Interfaces dependency moves from `0.5.0` to `0.9.0`. The starter's
  `role_assignment_name_use_random_uuid` default stays `true`, but switching from
  random to deterministic naming and back now reuses the retained UUID rather
  than generating another one.
- With `enable_telemetry = true`, the default, the saved upgrade plan shows more than
  telemetry state changes. The module manages resources through AzAPI, and the
  telemetry request headers set by `0.21.0` are removed, so those resources update
  in place. A role assignment given by role name can show `roleDefinitionId` as known
  after apply while the role lookup is deferred. In an isolated upgrade test the
  assignment ID and role were unchanged after apply. The new telemetry deployments
  also show an in-place update on every later plan because their `apply_id` output
  holds a timestamp, so `terraform plan -detailed-exitcode` and change-triggered
  approval gates always report changes. Confirm that no role assignment is replaced
  before you apply.

The ALZ module now requires AzAPI `~> 2.12`, which the starter's existing
`~> 2.0` constraint permits. Reinitialize after updating the starter files; if
your provider lock selects an older AzAPI version, run `terraform init -upgrade`
and review the updated dependency selections. Review the saved upgrade plan,
including telemetry state changes and any role assignment replacements, before
applying it. No manual state edits are required by this starter change.

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
