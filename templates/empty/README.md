# Azure Landing Zones Accelerator Starter Module for Terraform - Empty

This module is part of the Azure Landing Zones Accelerator solution. This configuration includes a minimal set of files (providers and GitHub Actions workflows) to get you started and then give you the option to create your own configuration.

## AVM Modules

You may reference the [Azure Landing Zone AVM modules](https://registry.terraform.io/search/modules?q=Azure%2Favm-ptn-alz) to build out your own configuration.

Each module has a drop down of examples to use as a starting point. For example, the [management example](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest/examples/management) for the core Azure Landing Zone pattern module.

If you would like to get started based on this example then follow the [quickstart](./QUICKSTART.md).

## Azure Landing Zone libraries

### The alz provider

The [alz provider](https://registry.terraform.io/providers/Azure/alz/latest/docs) creates the Azure Landing Zone library used by the main alz module to define assets such as:

- role definitions
- policy definitions
- policy initiative definitions
- policy assignments

These are then grouped using the following constructs

- archetypes, which are grouping of the assets above
- archetype overrides, which is a delta from an archetype
- architectures, representing the management group structure and assigned archetypes and overrides
- metadata (including dependency references to any other libraries) and default values for policies

### Microsoft maintained libraries

Microsoft maintains a structured set of versioned releases of libraries for Azure Landing Zone, Sovereign Landing Zone and more. Go to <https://aka.ms/alz/library> to see the most recent releases and changelog.

Example alz provider block using an official release:

```ruby
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      ref  = "2025.02.0"
    }
  ]
}
```

This will pull the alz library from <https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz?ref=2025.02.0>.

### Custom libraries

The alz provider and library format are designed to allow customization and extensibility. You can override the Microsoft libraries, modify assignments, create your own library of assets, extend or replace, and more.

Refer to the <https://azure.github.io/Azure-Landing-Zones-Library> documentation.
