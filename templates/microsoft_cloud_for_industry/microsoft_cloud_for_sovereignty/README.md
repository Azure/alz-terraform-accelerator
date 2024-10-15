# Azure Landing Zones Accelerator Starter Module for Terraform - Sovereign Landing Zone

This module is part of the Azure Landing Zones Accelerator solution. It is Sovereign Landing Zone implementation of the Azure Landing Zones Platform Landing Zone for Terraform.

It deploys the Sovereign Landing Zone (SLZ) with an equivalent compliance posture as to our [Bicep implementation](https://aka.ms/slz/bicep).

The module deploys the following resources:

- Management group hierarchy
- Management group scope for confidential computing resources
- Azure Policy definitions and assignments
- Sovereign Baseline Policy Initiatives
- Role definitions
- Management resources, including Log Analytics workspace and Automation account
- Hub virtual network including Azure Bastion and Azure Firewall
- DDOS protection plan
- Private DNS zones

## Usage

The module is intended to be used with the [Azure Landing Zones Accelerator](https://aka.ms/alz/accelerator/docs). Head over there to get started and review the microsoft_cloud_for_sovereignty starter module during Phase 2. A copy of the `inputs.yaml` file to use can be found [here](https://aka.ms/slz/terraform/inputs).

## Inputs.yaml Parameters

The inputs listed as `Required` are those that must be reviewed and potetially customized, if they are allowed during the public preview. All other values are suitable defaults, but may be changed as needed.

| Input | Required | Type | Default Value | Description |
| - | -- | --- | ---- | ----- |
| `iac` | Required | String | `"terraform"` | For public preview, only `"terraform"` is supported. |
| `bootstrap` | Required | String | `"alz_local"` | For public preview, only `"alz_local"` is supported. |
| `starter` | Required | String | `"microsoft_cloud_for_sovereignty"` | This value denotes to use the Sovereign Landing Zone. |
| `bootstrap_location` | Required | Location |  | For public preview, use the same value as the `default_location`. As of the current release, it is required but not used. |
| `starter_locations` | Required | Locations |  | For public preview, use the same value as the `default_location`. As of the current release, it is required but not used. |
| `root_parent_management_group_id` |  | MG ID |  | The Management Group ID to deploy the SLZ under. By default, it will be deployed at the tenant root group level. |
| `subscription_id_management` |  | Sub ID |  | This is the UUID value for a previously created management subscription. If left blank, a new subscription will be created. |
| `subscription_id_identity` |  | Sub ID |  | This is the UUID value for a previously created identity subscription. If left blank, a new subscription will be created. |
| `subscription_id_connectivity` |  | Sub ID |  | This is the UUID value for a previously created connectivity subscription. If left blank, a new subscription will be created. |
| `target_directory` |  | File Path | `""` | Local file path for the resulting Terraform to be deployed to. By default it is created under the current working directory in a directory named `local-output`. |
| `create_bootstrap_resources_in_azure` | Required | Boolean | `false` | For public preview, only `false` is supported. |
| `bootstrap_subscription_id` |  | Sub ID |  | For public preview, bootstrap is not is supported. |
| `service_name` |  | String | slz | For public preview, bootstrap naming is not is supported. |
| `environment_name` |  | String | mgmt | For public preview, bootstrap naming is not is supported. |
| `postfix_number` |  | Numeric | 1 | For public preview, bootstrap naming is not is supported. |
| `apply_alz_archetypes_via_architecture_definition_template` |  | Boolean | `true` | Set to `true` to deploy the default ALZ policy suite. |
| `allowed_locations` | Required | List |  | This is a list of Azure regions all workloads running outside of the Confidential Management Group scopes are allowed to be deployed into. |
| `allowed_locations_for_confidential_computing` | Required | List |  | This is a list of Azure regions all workloads running inside of the Confidential Management Group scopes are allowed to be deployed into. |
| `az_firewall_policies_enabled` |  | Boolean | `true` | Set to `true` to deploy a default Azure Firewall Policy resource if `enable_firewall` is also `true`. |
| `bastion_outbound_ssh_rdp_ports` |  | List | `["22", "3389"]` | List of outbound remote access ports to enable on the Azure Bastion NSG if `deploy_bastion` is also `true`. |
| `custom_subnets` |  | Map | See `inputs.yaml` for default object. | Map of subnets and their configurations to create within the hub network. |
| `customer` |  | String | `"Country/Region"` | Customer name to use when branding the compliance dashboard. |
| `customer_policy_sets` |  | Map | See the Custom Compliance section below for details. | Map of customer specified policy initiatives to apply alongside the SLZ. |
| `default_location` | Required | Location |  | This is the Azure region to deploy all SLZ resources into. |
| `default_postfix` |  | String |  | Postfix value to append to all resources. |
| `default_prefix` | Required | String | `mcfs` | Prefix value to append to all resources. |
| `deploy_bastion` |  | Boolean | `true` | Set to `true` to deploy Azure Bastion within the hub network. |
| `deploy_ddos_protection` |  | Boolean | `true` | Set to `true` to deploy Azure DDoS Protection within the hub network. |
| `deploy_hub_network` |  | Boolean | `true` | Set to `true` to deploy the hub network. |
| `deploy_log_analytics_workspace` |  | Boolean | `true` | Set to `true` to deploy Azure Log Analytics Workspace. |
| `enable_firewall` |  | Boolean | `true` | Set to `true` to deploy Azure Firewall within the hub network. |
| `enable_telemetry` |  | Boolean | `true` | Set to `false` to opt out of telemetry tracking. We use telemetry data to understand usage rates to help prioritize future development efforts. |
| `express_route_gateway_config` |  | Map | `{name: "noconfigEr"}` | Leave as default to not deploy an ExpressRoute Gateway. See the Network Connectivity section below for details. |
| `hub_network_address_prefix` |  | CIDR | "10.20.0.0/16" | This is the CIDR to use for the hub network. |
| `landing_zone_management_group_children` |  | Map |  | See the Customize Application Landing Zones section below for details. |
| `log_analytics_workspace_retention_in_days` |  | Numeric | 365 | Number of days to retain logs in the Log Analytics Workspace. |
| `ms_defender_for_cloud_email_security_contact` |  | Email | `security_contact@replaceme.com` | Email address to use for Microsoft Defender for Cloud. |
| `policy_assignment_enforcement_mode` |  | String | `Default` | The enforcement mode to use for the Sovereign Baseline Policy initiatives. |
| `policy_effect` |  | String | `Deny` | The effect to use for the Sovereign Baseline Policy initiatives, when policies support multiple effects. |
| `policy_exemptions` |  | Map | See the Custom Compliance section below for details. | Map of customer specified policy exemptions to use alongside the SLZ. |
| `subscription_billing_scope` |  | String |  | Only required if you have not provided existing subscription IDs for management, connectivity, and identity. |
| `tags` |  | Map | See the Custom Tagging section below for details. | Set of tags to apply to all resources deployed. |
| `use_premium_firewall` |  | Boolean | `true` | Set to `true` to deploy Premium SKU of the Azure Firewall if `enable_firewall` is also `true`. |
| `vpn_gateway_config` |  | Map | `{name: "noconfigEr"}` | Leave as default to not deploy an VPN Gateway. See the Network Connectivity section below for details. |
| `bootstrap_module_version` |  | String | `v4.0.5` | For public preview, only `"v4.0.5"` is supported. |
| `starter_module_version` |  | String | `latest` | For public preview, only `"latest"` is supported. |

## Custom Compliance

### Custom Policy Sets

An example of the format for the `customer_policy_sets` map is as follows:

```yaml
customer_policy_sets: {
  assignment1: {
    policySetDefinitionId: "/providers/Microsoft.Authorization/policySetDefinitions/d5264498-16f4-418a-b659-fa7ef418175f",
    policySetAssignmentName: "FedRAMPHigh",
    policySetAssignmentDisplayName: "FedRAMP High",
    policySetAssignmentDescription: "FedRAMP High",
    policySetManagementGroupAssignmentScope: "/providers/Microsoft.management/managementGroups/<MG-ID-SCOPE>",
    policyParameterFilePath: "./policy_parameters/policySetParameterSampleFile.json"
  }
}
```

### Policy Exemptions

An example of the format for the `policy_exemptions` map is as follows:

```yaml
policy_exemptions: {
  policy_exemption1: {
    name: "globalexemption",
    display_name: "global",
    description: "test",
    management_group_id: "/providers/Microsoft.management/managementGroups/<MG-ID-SCOPE>",
    policy_assignment_id: "/providers/microsoft.management/managementGroups/<MG-ID-SCOPE>/providers/microsoft.Authorization/policyassignments/enforce-sovereign-global",
    policy_definition_reference_ids: ["AllowedLocations"]
  }
}
```

## Customize Application Landing Zones

### Landing Zone Management Group Children

An example of the format for the `landing_zone_management_group_children` map is as follows:

```yaml
landing_zone_management_group_children: {
  child1: {
    id: "child1",
    display_name: "Landing zone child one"
  }
}
```

## Custom Tagging

### Tags

An example of the format for the `tags` map is as follows:

```yaml
tags: {
  Environment: "Production",
  ServiceName: "SLZ"
}
```

## Network Connectivity

### ExpressRoute Gateway Config

An example of the format for the `express_route_gateway_config` map is as follows:

```yaml
express_route_gateway_config: {
  name: "express_route",
  gatewayType: "ExpressRoute",
  sku: "ErGw1AZ",
  vpnType: "RouteBased",
  vpnGatewayGeneration: null,
  enableBgp: false,
  activeActive: false,
  enableBgpRouteTranslationForNat: false,
  enableDnsForwarding: false,
  asn: 65515,
  bgpPeeringAddress: "",
  peerWeight: 5,
  vpnClientConfiguration: {
    vpnAddressSpace: ["10.2.0.0/24"]
  }
}
```

### VPN Gateway Config

An example of the format for the `vpn_gateway_config` map is as follows:

```yaml
vpn_gateway_config: {
  name: "vpn_gateway",
  gatewayType: "Vpn",
  sku: "VpnGw1",
  vpnType: "RouteBased",
  vpnGatewayGeneration: "Generation1",
  enableBgp: false,
  activeActive: false,
  enableBgpRouteTranslationForNat: false,
  enableDnsForwarding: false,
  bgpPeeringAddress: "",
  asn: 65515,
  peerWeight: 5,
  vpnClientConfiguration: {
    vpnAddressSpace: ["10.2.0.0/24"]
  }
}
```

## Known Issues

The following are known issues with the Public Preview release for the SLZ.

### Multiple Resources Destroyed and Recreated During Second Execution

Occasionally, terraform will attempt to recreate many resources under a subscription despite no resource configurations being changed. A temporary work around can be done by updating `locals.tf` with the following:

```terraform
locals {
  subscription_id_management   = "management_subscription_id"
  subscription_id_connectivity = "connectivity_subscription_id"
  subscription_id_identity     = "identity_subscription_id"
}
```

### Multiple Inputs for Location

The inputs for `bootstrap_location` and `starter_locations` and `default_location` must be identical. In a future release, we will have defaults and overrides for these values.

### Terraform Plan or Apply Fails After Updating tfvars

Any updates should be made to the `inputs.yaml` file and the tfvars will be updated upon executing the `Deploy-Accelerator` PowerShell command.

### Invalid Hub Network Address Prefix or Subnet Address Prefix

There is no validation done to ensure subnets fall within the hub network CIDR or that subnets do not overlap. These issues will be uncovered during apply.

### Unable to Build Authorizer for Resource Manager API

It is necessary to rerun `az login` after creating subscriptions for terraform to pick up that they exist.

### Unable to Update Address Prefixes

Updating the address prefix on either the hub network or subnets is not supported at this time.

### Unable to Change Top Level or Sub Level Management Group Names

Modifying the Top Level or Sub Level Management Group name is not supported at this time.

### Tags are Not Applied to All Resources

Certain resources are not receiving the default tags. This will be addressed in a future release.

### Default Compliance Score is not 100%

Certain resources will show as being out of compliance by default. This will be addressed in a future release.
