<!-- markdownlint-disable first-line-h1 -->

## Scenario 1 - Secure island for seed resources

Depending on your security needs, you may wish to store the Azure resources deployed by the bootstrap in separate subscription and optionally a separate management group hierarchy to the Azure Landing Zone. This could be the case when you need to separate the concerns of deploying and maintaining the Azure Landing Zone from the day to day access of the Azure Landing Zone.

The resources deployed by the bootstrap vary depending on the options you choose, but they may include the following:

- Storage account for state file
- User assigned managed identities
- [Optional] Self hosted agents
- [Optional] Networking, DNS and Private End Point for storage account

In order to use the secure island approach, you can follow these steps:

### Option 1 - Separate subscription under separate management group hierarchy

1. Create a new management group under `Tenant Root Group`.
1. Apply your desired policies and permissions to the new management group.
1. Create a new subscription for the seed resources and place it in the new management group. Take note of the subscription id.
1. Grant owner rights to the account you are using to deploy the accelerator on the new subscription.
1. Run the bootstrap as normal, following the instructions in the [Quick Start][wiki_quick_start] guide.
1. When you get to step 2.2.1 (GitHub), 2.2.2 (Azure DevOps) or 2.2.3 (Local), enter the subscription id of the new subscription you created into the `azure_subscription_id` field.
1. Continue with the rest of the steps in the [Quick Start][wiki_quick_start] guide.

This will result in the seed resources being deployed in the new subscription and management group hierarchy, while the Azure Landing Zone is deployed into the defined management group hierarchy.

### Option 2 - Separate subscription under Azure Landing Zones management group hierarchy

1. Create a new subscription for the seed resources. Take note of the subscription id.
2. Grant owner rights to the account you are using to deploy the accelerator on the new subscription.
3. Use the `complete` starter module to deploy the Azure Landing Zone.
4. Update the `config.yaml` file to include subscription placement for the new subscription:

```yaml
archetypes:  # `caf-enterprise-scale` module, add inputs as listed on the module registry where necessary.
  root_name: es
  root_id: Enterprise-Scale
  deploy_corp_landing_zones: true
  deploy_online_landing_zones: true
  default_location: uksouth
  disable_telemetry: true
  deploy_management_resources: true
  configure_management_resources:
    location: uksouth
    settings:
      security_center:
        config:
          email_security_contact: "security_contact@replace_me"
    advanced:
      asc_export_resource_group_name: rg-asc-export
      custom_settings_by_resource_type:
        azurerm_resource_group:
          management:
            name: rg-management
        azurerm_log_analytics_workspace:
          management:
            name: log-management
        azurerm_automation_account:
          management:
            name: aa-management
  subscription-id-overrides:
    management:
      - 00000000-0000-0000-0000-000000000000  # Your new subscription id
```

5. Run the bootstrap as normal, following the instructions in the [Quick Start][wiki_quick_start] guide.
6. When you get to step 2.2.1 (GitHub), 2.2.2 (Azure DevOps) or 2.2.3 (Local), enter the subscription id of the new subscription you created into the `azure_subscription_id` field.
7. Continue with the rest of the steps in the [Quick Start][wiki_quick_start] guide.

This will result in the seed resources being deployed in the new subscription. When you then deploy the Azure Landing Zone your subscription will be moved under the `management` management group.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_quick_start]:                                                  %5BUser-Guide%5D-Quick-Start "Wiki - Quick start"
