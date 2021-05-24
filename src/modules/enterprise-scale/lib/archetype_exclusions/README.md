# Archetype Exclusions

This folder is the recommended location to store custom Archetype Exclusions.

Archetype Exclusions provide the ability to remove the specified resources (by type) from the built-in Archetype Definitions. This reduces operational overheads by allowing customers to benefit from updates between module releases without having to maintain a full copy of the built-in Archetype Definition in their custom library.

Each Archetype Exclusion should be saved with a file name matching the following pattern:

`archetype_exclusion_*.json`

Additionally, Archetype Exclusions work by adding the prefix `exclude_` to the name of the Archetype Definition you want to amend.

The basic structure of an Archetype Exclusion is based on the following JSON construct:

```json
{
    "exclude_my_custom_archetype": {
        "policy_assignments": [
            "Deploy-AKS-Policy",
            "Deny-Priv-Escalation-AKS",
            "Deny-Priv-Containers-AKS",
            "Deny-http-Ingress-AKS"
        ],
        "policy_definitions": [],
        "policy_set_definitions": [],
        "role_definitions": [],
        "archetype_config": {
            "parameters": {},
            "access_control": {}
        }
    }
}
```

This example defines exclusions for the Archetype Definition `my_custom_archetype`, removing the following `policy_assignments` from the `my_custom_archetype` Archetype Definition:

- Deploy-AKS-Policy
- Deny-Priv-Escalation-AKS
- Deny-Priv-Containers-AKS
- Deny-http-Ingress-AKS

When creating your own Archetype Exclusion please note the following:

- Terraform is `Case Sensitive`, so please take care to use the correct casing on both `keys` and `values`
- The `jsondecode()` function in Terraform does NOT support JSON with comments
- All template references for `policy_assignments`, `policy_definitions`, and `policy_set_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.name` field within the template
- All template references for `role_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.properties.roleName` field within the template *(this difference is due to the `.name` field needing to be a valid `GUID` which isn't easy to work with)*
- Support in the Archetype Exclusion template is currently limited to the following fields:
  - `policy_assignments`
  - `policy_definitions`
  - `policy_set_definitions`
  - `role_definitions`
- Values provided in the `archetype_config` object will be ignored
- Take care when creating exclusions to ensure

For more information, please refer to the [Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions) page on the Wiki.