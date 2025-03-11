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

## Inputs Parameters

The description of inputs for this module are found in ALZ Accelerator documentation [here](https://aka.ms/slz/terraform/inputs).

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

## Customize Management Group Configuration

### Default Management Group Configuration

NOTE - management_group_configuration archetypes array can be used for including non-ALZ archetypes.
ALZ archetypes can be toggled using input variable apply_alz_archetypes_via_architecture_definition_template.

All archetypes(ALZ/SLZ) can be found [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/slz/README.md).

The default format for the `management_group_configuration` map is as follows:

```yaml
management_group_configuration: {
  root: {
    id: "${default_prefix}${optional_postfix}",
    display_name: "Sovereign Landing Zone",
    archetypes: ["global"]
  },
  platform: {
    id: "${default_prefix}-platform${optional_postfix}",
    display_name: "Platform",
    archetypes: []
  },
  landingzones: {
    id: "${default_prefix}-landingzones${optional_postfix}",
    display_name: "Landing Zones",
    archetypes: []
  },
  decommissioned: {
    id: "${default_prefix}-decommissioned${optional_postfix}",
    display_name: "Decommissioned",
    archetypes: []
  },
  sandbox: {
    id: "${default_prefix}-sandbox${optional_postfix}",
    display_name: "Sandbox",
    archetypes: []
  },
  management: {
    id: "${default_prefix}-platform-management${optional_postfix}",
    display_name: "Management",
    archetypes: []
  },
  connectivity: {
    id: "${default_prefix}-platform-connectivity${optional_postfix}",
    display_name: "Connectivity",
    archetypes: []
  },
  identity: {
    id: "${default_prefix}-platform-identity${optional_postfix}",
    display_name: "Identity",
    archetypes: []
  },
  corp: {
    id: "${default_prefix}-landingzones-corp${optional_postfix}",
    display_name: "Corp",
    archetypes: []
  },
  online: {
    id: "${default_prefix}-landingzones-online${optional_postfix}",
    display_name: "Online",
    archetypes: []
  },
  confidential_corp: {
    id: "${default_prefix}-landingzones-confidential-corp${optional_postfix}",
    display_name: "Confidential Corp",
    archetypes: ["confidential"]
  },
  confidential_online: {
    id: "${default_prefix}-landingzones-confidential-online${optional_postfix}",
    display_name: "Confidential Online",
    archetypes: ["confidential"]
  }
}
```

## Customize Application Platform/Landing Zones

### Landing Zone Management Group Children

An example of the format for the `landing_zone_management_group_children` map is as follows:

```yaml
landing_zone_management_group_children: {
  child1: {
      id: "${default_prefix}-landingzones-child1${optional_postfix}",
      display_name: "Landing zone child one",
      archetypes: []
  }
}
```

### Platform Management Group Children

An example of the format for the `platform_management_group_children` map is as follows:

```yaml
platform_management_group_children: {
    security: {
      id: "${default_prefix}-platform-security${optional_postfix}",
      display_name: "Security",
      archetypes: ["confidential"]
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
  peerWeight: 5
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

### Unable to update the bastion subnet

Workaround:
Set deploy_bastion= false in inputs file
Run deployAccelerator command
Run .\scripts\deploy-local.ps1
Set deploy_bastion= true in inputs file, update AzureBastionSubnet address_prefix
Run deployAccelerator command
Run .\scripts\deploy-local.ps1

### Unable to update the firewall subnet

Work around:
Set deploy_bastion= false and enable_firewall = false in inputs file
Run deployAccelerator command
Run .\scripts\deploy-local.ps1
Set deploy_bastion= true and enable_firewall = true in inputs file, update AzureFirewallSubnet address_prefix
Run deployAccelerator command

### Tags are Not Applied to All Resources

Certain resources are not receiving the default tags. This will be addressed in a future release.

### Default Compliance Score is not 100%

Certain resources will show as being out of compliance by default. This will be addressed in a future release.

## Notes about Policy Remediations

1. Policy Definition [migrateToMdeTvm](/providers/Microsoft.Authorization/policyDefinitions/766e621d-ba95-4e43-a6f2-e945db3d7888) will be excluded from remediation as customers must [enable MDFC](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription?WT.mc_id=Portal-HubsExtension) on their subscriptions for this policy and then run remediation via Azure portal.

2. Log analytics polices deploy-diag-logscat and deploy-azactivity-log will be skipped for remediation until customer has set the log_analytics_workspace_resource_id(output after successful deployment of LZ) input and re-run deploy-accelerator/deploy-local.ps1.

3. Updating assignment policies or management group configuration will trigger recreation of azapi policy remediation resources -
Because customers have the option to include custom policies with built-in policy set definitions, and remediations require the policyReferenceId for policy definitions in policy sets, the policyReferenceId must be queried dynamically and due to Terraform's limitations on creating resources in a for_each, remediations will get recreated as the result of a workaround for allowing this dynamic query.
Remediation tasks will only be created if a policy is not in compliance.

There is an experimental feature that would allow the dynamic creation of resources in a for_each, but work on this is on-going.

## Notes running on non-global admin service principal

To deploy with lowered permissions using a service principal with "Owner" role assignment at the tenant root management group, set the following environment variable in powershell:

```powershell
$env:AZAPI_RETRY_GET_AFTER_PUT_MAX_TIME="30m"
```

## Notes on required permissions for optional security group creation

The following permissions are needed for [security group creation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)

Security group creation can be disabled by setting input `management_security_groups = []`. Also, security groups in management_security_groups are case-sensitive.

## Instructions for using custom policies and updating parameter values for ALZ or SLZ policies

Custom policies can be added to the `lib` directory in the root of the starter module. Here is an example in the [AVM terraform-azurerm-avm-ptn-alz](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/tree/main/examples/policy-assignment-modification-with-custom-lib/lib) repo.

NOTE - Customers can also include custom [policy set definition](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/fsi/policy_set_definitions/SO-01-Data-Residency.alz_policy_set_definition.json) and
[policy definition](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/policy_definitions/Append-AppService-latestTLS.alz_policy_definition.json) ARM templates into the `lib` directory.
File names must contain the same format as in the given examples.

Customers can also update policy parameter values for ALZ or SLZ policies by including an updated copy of the policy file in the `lib` directory. The new file will overwrite the existing policy file in the module. The new file must contain the same format as the original policy file.

## Instructions updating policy default values

In the starter module locals.tf, customers can update the slz_policy_default_values for any of the parameters set in this [example](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/blob/main/examples/management/main.tf#L43C4-L50).

```terraform
slz_policy_default_values = {
  slz_policy_effect                            = jsonencode({ value = var.policy_effect })
  list_of_allowed_locations                    = jsonencode({ value = var.allowed_locations })
  allowed_locations_for_confidential_computing = jsonencode({ value = var.allowed_locations_for_confidential_computing })
  ddos_protection_plan_id                      = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder" })
  ddos_protection_plan_effect                  = jsonencode({ value = var.deploy_ddos_protection ? "Audit" : "Disabled" })
  email_security_contact                       = jsonencode({ value = var.ms_defender_for_cloud_email_security_contact })
  ama_user_assigned_managed_identity_id        = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.uami_name}" })
  ama_user_assigned_managed_identity_name      = jsonencode({ value = local.uami_name })
  log_analytics_workspace_id                   = jsonencode({ value = var.log_analytics_workspace_resource_id })
}
```
