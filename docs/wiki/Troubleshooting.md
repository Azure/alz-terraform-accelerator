<!-- markdownlint-disable first-line-h1 -->
Having trouble using the module and unable to find a solution in the Wiki?

If it isn't listed below, let us know about it in our [Issues][Issues] log. We'll do our best to help and you may find your issue documented here.

## Error: containers.Client#GetProperties: Failure responding to request: StatusCode=403

```text
Error: retrieving Container "mgmt-tfstate" (Account "stoalzazwmgmtuks001bqox" / Resource Group "rg-alzazw-mgmt-state-uksouth-001"): containers.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:2ebdbd0b-601e-0070-2610-443cbb000000\nTime:2024-01-10T21:59:17.0820266Z"
```

You will see this error if you set the `allow_storage_access_from_my_ip` variable to `false` and you are attempting a second run of the accelerator. This is because the storage account has public access disabled and access is required from your IP address to the storage account to read the storage container. This is an unfortunate limitation of the Terraform AzureRM provider.

To resolve this follow these steps:

1. Navigate to your storage account in the Azure Portal.
2. Select `Networking` from the left-hand menu.
3. Check the option `Enabled from selected virtual networks and IP addresses` under the `Public network access` section.
4. Check the `Add your client IP address ('123.12.34.123')` box.
5. Click `Save`.

Now you can re-run the accelerator and it will work.

> NOTE: If you still don't set the `allow_storage_access_from_my_ip` variable to `true` you will see the same error if you run it again.

<!-- markdownlint-enable no-inline-html -->

[Issues]:     https://github.com/Azure/alz-terraform-accelerator/issues "Our issues log"
