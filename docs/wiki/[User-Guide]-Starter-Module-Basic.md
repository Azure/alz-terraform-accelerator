<!-- markdownlint-disable first-line-h1 -->

The `basic` starter module creates a management group hierarchy and assigns policies.

## Inputs

- `default_location`: The location for Azure resources (e.g 'uksouth').
- `subscription_id_connectivity`: The identifier of the Connectivity Subscription.
- `subscription_id_identity`: The identifier of the Identity Subscription.
- `subscription_id_management`: The identifier of the Management Subscription.
- `root_id`: The root id is the identity for the root managment group and a prefix applied to all management group identities.
- `root_name`: The display name for the root management group.