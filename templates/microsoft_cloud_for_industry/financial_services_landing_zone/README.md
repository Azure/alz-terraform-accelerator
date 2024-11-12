# Azure Landing Zones Accelerator Starter Module for Terraform - Financial Services Industry Landing Zone

This module is part of the Azure Landing Zones Accelerator solution. It is Financial Services Industry Landing Zone implementation of the Azure Landing Zones Platform Landing Zone for Terraform.
It deploys the Financial Services Industry Landing Zone (FSILZ) with an equivalent compliance posture

The module deploys the following resources:

- Management group hierarchy
- Management group scope for confidential computing resources
- Azure Policy definitions and assignments
- Policy Initiatives
- Role definitions
- Management resources, including Log Analytics workspace and Automation account
- Hub virtual network including Azure Bastion and Azure Firewall
- DDOS protection plan
- Private DNS zones

## Policy Assignments

It deploys all the ALZ (Microsoft Cloud Security Benchmark) Policy at the root level along with Data Residency, Customer Managed Key, Zone Residency, Transparency & Logging. Financial Services Industry Confidential Policy is assigned at Confidential level.

## Usage

The module is intended to be used with the [Azure Landing Zones Accelerator](https://aka.ms/alz/accelerator/docs). Head over there to get started and review the financial_services_landing_zone
starter module during Phase 2. A copy of the `inputs.yaml` file to use can be found [here](https://aka.ms/fsi/terraform/inputs).

## Inputs Parameters

The description of inputs for this module are found in ALZ Accelerator documentation [here](https://aka.ms/fsi/terraform/inputs).

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
    policy_assignment_id: "/providers/microsoft.management/managementGroups/<MG-ID-SCOPE>/providers/microsoft.Authorization/policyassignments/enforce-fsi-global",
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
  ServiceName: "FSILZ"
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

The following are known issues with the Public Preview release for the Financial Services Industry Landing Zone (FSILZ).

### Multiple Inputs for Location

The inputs for `bootstrap_location` and `starter_locations` must be identical.

### Terraform Plan or Apply Fails After Updating tfvars

Any updates should be made to the `inputs.yaml` and run the ALZ powershell & rerun the Phase 3 of Deployment.

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
