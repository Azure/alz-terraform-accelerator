<!-- markdownlint-disable first-line-h1 -->

## Scenario 1 - Secure island for seed resources

Depending on your security needs, you may not wish to store the Azure resources deployed by the bootstrap in separate subscription and management group hierarchy to the Azure Landing Zone. This could be the case when you need to separate concerns of deploying and maintaining the Azure Landing Zone from the day to day access of the Azure Landing Zone.

The resources deployed by the boostrap vary depending on the options you choose, but they may include the following:

- Storage account for state file
- User assigned managed identities
- [Optional] Self hosted agents
- [Optional] Networking, DNS and Private End Point for storage account

In order to use the secure island approach, you need to follow these steps:

1. Create a new management group under `Tenant Root Group`.
1. Apply your desired policies and permissions to the new management group.
1. Create a new subscription for the seed resources and place it in the new management group. Take note of the subscription id.
1. Grant owner rights to the account you are using to deploy the accelerator on the new subscriptions.
1. Run the bootstrap as normal, following the instructions in the [Quick Start][wiki_quick_start] guide.
1. When you get to step 2.2.1 (GitHub), 2.2.2 (Azure DevOps) or 2.2.3 (Local), enter the subscription id of the new subscription you created into the `azure_subscription_id` field.
1. Continue with the rest of the steps in the [Quick Start][wiki_quick_start] guide.

This will result in the seed resources being deployed in the new subscription and management group hierarchy, while the Azure Landing Zone is deployed into the defined management group hierarchy.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_quick_start]:                                                  %5BUser-Guide%5D-Quick-Start "Wiki - Quick start"
