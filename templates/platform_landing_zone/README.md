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

### Customer-owned public IPs for secured Virtual WAN hubs

This option requires a Virtual WAN pattern release that implements customer-owned firewall IPs. Earlier releases discard the field, because it is absent from their typed schema. Confirm the version pinned in `main.connectivity.virtual.wan.tf` supports it before enabling customer mode.

The optional input is `virtual_hubs[hub_key].firewall.ip_configurations[stable_key]`. Each entry requires `name` and `public_ip_address_id`. Omitted or `null` maps become `{}`. Use stable, plan-known map keys, unique configuration names and distinct public IP resource IDs.

| Customer IP map | `vhub_public_ip_count` | Mode |
| --- | --- | --- |
| Empty | Omitted or `null` | Existing managed-IP default, unchanged |
| Empty | Positive integer as a string | Managed IPs with that count |
| Nonempty | Omitted, `null` or `"0"` | Customer-only IPs; no additional managed allocation |
| Nonempty | Positive managed count | Invalid; the supporting pattern rejects mixed ownership |
| Empty | `"0"` | Invalid; public-IP-less mode is not supported |

The public count remains a **string**, not a new numeric input. The supporting pattern owns count validation, IP prerequisite checks and mode-transition protection.

Merge this `firewall` fragment into the chosen existing hub definition, retaining its other firewall settings and the scenario's enabled components. It is not a complete `.tfvars` file. Terraform does not deep-merge `virtual_hubs` between variable files.

```hcl
firewall = {
  name     = "$${primary_firewall_name}"
  sku_tier = "$${primary_firewall_sku_tier}"
  ip_configurations = {
    primary = {
      name                 = "fw-ip-primary"
      public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-public-ips/providers/Microsoft.Network/publicIPAddresses/pip-fw-primary"
    }
    secondary = {
      name                 = "fw-ip-secondary"
      public_ip_address_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/rg-public-ips/providers/Microsoft.Network/publicIPAddresses/pip-fw-secondary"
    }
  }
}
```

Public IPs must meet the [secured-hub prerequisites](https://learn.microsoft.com/azure/firewall/secured-hub-customer-public-ip): Standard SKU, Regional tier, IPv4, static allocation, the firewall's subscription and the hub's region, and no association with another resource.
Their availability zones must match the firewall's: a public IP with no zones is rejected at plan time, but one whose zones differ from the firewall's is rejected by Azure during apply.
The firewall must use the `Standard` or `Premium` SKU tier. The firewall attaches caller-owned IPs; it does not create or own their lifecycle.

Literal IDs and the existing built-in/custom replacements are supported. For an ID created in the same apply, pass the resource or module output directly as `public_ip_address_id` in an HCL module call; resource expressions cannot be used in `.tfvars`. Keep hub/configuration keys and other hub structure known at plan time. Do not put apply-time IDs into the shared `custom_replacements` map.

The config helper still resolves the replacement context and templates the hub structure. Only the new public IP ID leaves are kept outside its whole-hub JSON encoding and restored before the pattern call, so an unknown ID does not make hub/configuration keys unknown. `templated_inputs` includes the restored IDs.

Customer IPs are supported on new firewalls, and IPs can be added, removed or replaced on a firewall already in customer mode. Plan these changes as maintenance: they update the firewall in place, but are not guaranteed to be outage-free.
Converting an existing firewall between managed and customer IPs, including by removing its last customer IP, is not supported and is blocked by the supporting pattern.

#### Upgrading an already-generated repository

Updating this Accelerator template does not update repositories that were generated earlier. In the generated platform module:

1. Review and merge the typed input change in `variables.connectivity.virtual.wan.tf`, the forwarding changes in `main.config.tf` and `locals.tf`, and the corresponding `templated_inputs` change in `outputs.tf`. Preserve local customizations, including `base_policy_id`, policy/library configuration and scenario enabled flags.
1. Update the Virtual WAN module version to a release that implements customer-owned firewall IPs.
1. Map **both** providers in the Virtual WAN module call: `azurerm = azurerm.connectivity` and `azapi = azapi.connectivity`. The default AzAPI provider targets the management subscription. The existing AzureRM 4.x and AzAPI 2.x major version constraints are unchanged.
1. Keep existing managed deployments in managed mode during the upgrade: keep their `vhub_public_ip_count` and leave `ip_configurations` empty. Back up state before applying. The upgrade does not require state commands, imports or `moved` blocks in your configuration.
1. Review the plan and stop if it shows unexpected creates, deletes or replacements. After applying, run a follow-up plan and confirm that it shows no changes.
1. Add customer IPs only to a new firewall, or change IPs on a firewall already in customer mode. Do not combine the module upgrade with a mode change.

Local consumer checks are documented in [tests/README.md](tests/README.md). They test the input schema and forwarding with mocked providers; they do not deploy to Azure.
