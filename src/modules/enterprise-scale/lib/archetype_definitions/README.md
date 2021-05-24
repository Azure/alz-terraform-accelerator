# Archetype Definitions

This folder is the recommended location to store custom Archetype Definitions.

Each Archetype Definition should be saved with a file name matching the following pattern:

`archetype_definition_*.json`

The basic structure of an Archetype Definition is based on the following JSON construct:

```json
{
    "my_custom_archetype": {
        "policy_assignments": [
            "Deny-IP-Forwarding",
            "Deny-RDP-From-Internet",
            "Deny-Storage-http",
            "Deny-Subnet-Without-Nsg",
            "Deploy-AKS-Policy",
            "Deploy-SQL-DB-Auditing",
            "Deploy-VM-Backup",
            "Deploy-SQL-Security",
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

This example defines the requirement to create the following Policy Assignments at any scope where `my_custom_archetype` is specified as the `archetype_id` within the `archetype_config` for Landing Zones:

- Deny-IP-Forwarding
- Deny-RDP-From-Internet
- Deny-Storage-http
- Deny-Subnet-Without-Nsg
- Deploy-AKS-Policy
- Deploy-SQL-DB-Auditing
- Deploy-VM-Backup
- Deploy-SQL-Security
- Deny-Priv-Escalation-AKS
- Deny-Priv-Containers-AKS
- Deny-http-Ingress-AKS

> To see more examples of Archetype Definitions, please refer to the [built-in library](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib/archetype_definitions) within the module repository. These not only give you an idea of how each archetype is configured, but can also be used as a great starting point when creating your own. This is also a great way to understand what is in the built-in archetypes, and therefore what will be deployed by the module at each scope.

When creating your own Archetype Definition please note the following:

- Terraform is `Case Sensitive`, so please take care to use the correct casing on both `keys` and `values`
- The `jsondecode()` function in Terraform does NOT support JSON with comments
- Archetype Definitions stored in the "custom library" take precedence over the built-in library if a naming conflict occurs - this can be useful if you want to override a built-in Archetype Definition, but we would recommend to use the Archetype Extension and Archetype Exclusion options in most cases
- All template references for `policy_assignments`, `policy_definitions`, and `policy_set_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.name` field within the template
- All template references for `role_definitions` must refer to a valid template within the built-in or custom library - these must match the expected naming patterns, and each list value is a string referring to the `.properties.roleName` field within the template *(this difference is due to the `.name` field needing to be a valid `GUID` which isn't easy to work with)*
- The Enterprise-scale recommendation is to only define `policy_definitions`,  `policy_set_definitions`, and `role_definitions` at the `root` scope so they can be used at all child scopes, unless for the purpose of testing

For more information, please refer to the [Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions) page on the Wiki.