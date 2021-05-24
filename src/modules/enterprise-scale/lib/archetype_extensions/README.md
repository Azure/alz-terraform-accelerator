# Archetype Extensions

This folder is the recommended location to store custom Archetype Extensions.

Archetype Extensions provide the ability to add the specified resources (by type) to the built-in Archetype Definitions. This reduces operational overheads by allowing customers to benefit from updates between module releases without having to maintain a full copy of the built-in Archetype Definition in their custom library.

Each Archetype Extension should be saved with a file name matching the following pattern:

`archetype_Extension_*.json`

Additionally, Archetype Extensions work by adding the prefix `extend_` to the name of the Archetype Definition you want to amend.

The basic structure of an Archetype Extension is based on the following JSON construct:

```json
{
    "extend_my_custom_archetype": {
        "policy_assignments": [
            "Deny-Resource-Locations",
            "Deny-RSG-Locations"
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

This example defines extensions for the Archetype Definition `my_custom_archetype`, adding the following `policy_assignments` to the `my_custom_archetype` Archetype Definition:

- Deny-Resource-Locations
- Deny-RSG-Locations

> **NOTE:** Whilst not officially part of the Enterprise-scale reference implementation, these popular Policy Assignments are included within the built-in library. 

When creating your own Archetype Extension please note the following:

- Terraform is `Case Sensitive`, so please take care to use the correct casing on both `keys` and `values`
- The `jsondecode()` function in Terraform does NOT support JSON with comments
- All template references for `policy_assignments`, `policy_definitions`, and `policy_set_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.name` field within the template
- All template references for `role_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.properties.roleName` field within the template *(this difference is due to the `.name` field needing to be a valid `GUID` which isn't easy to work with)*
- Support in the Archetype Extension template is currently limited to the following fields:
  - `policy_assignments`
  - `policy_definitions`
  - `policy_set_definitions`
  - `role_definitions`
- Values provided in the `archetype_config` object will be ignored
- Take care when creating Extensions to ensure

For more information, please refer to the [Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions) page on the Wiki.