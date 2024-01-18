<!-- markdownlint-disable first-line-h1 -->
### 2.2.1 Azure DevOps

1. In your PowerShell Core (pwsh) terminal type `New-ALZEnvironment -i "terraform" -c "azuredevops"`.
1. The module will download the latest accelerator and then prompt you for inputs.
1. Fill out the following inputs:
    1. `starter_module`: This is the choice of [Starter Modules][wiki_starter_modules], which is the baseline configuration you want for your Azure landing zone. This also determine the second set of input you'll be prompted for here.
    1. `azure_devops_personal_access_token`: Enter the Azure DevOps PAT you generated in a previous step.
    1. `azure_devops_organization_name`: Enter the name of your Azure DevOps organization. This is the section of the url after `dev.azure.com` or before `.visualstudio.com`. E.g. enter `my-org` for `https://dev.azure.com/my-org`.
    1. `use_separate_repository_for_pipeline_templates`: Determine whether to create a separate repository to store pipeline templates as an extra layer of security. Set to `false` if you don't wish to secure you pipeline templates by using a separate repository. This will default to `true`.
    1. `bootstrap_location`: Enter the Azure region where you would like to deploy the storage account and identity for your continuous delivery pipeline. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`.
    1. `bootstrap_subscription_id`: Enter the id of the subscription in which you would like to deploy the storage account and identity for your continuous delivery pipeline. If left blank, the subscription you are connected to via `az login` will be used. In most cases this is the management subscription.
    1. `service_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this.
    1. `environment_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this.
    1. `postfix_number`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this.
    1. `azure_devops_use_organisation_legacy_url`: If you have not migrated to the modern url (still using `https://<organization_name>.visualstudio.com`) for your Azure DevOps organisation, then set this to `true`. This is ignored if you supply an fqdn to `version_control_system_organization`.
    1. `azure_devops_create_project`: If you have an existing project you want to use rather than creating a new one, select `true`. We recommend creating a new project to ensure it is isolated by a strong security boundary.
    1. `azure_devops_project_name`: Enter the name of the Azure DevOps project to create or the name of an existing project if you set `azure_devops_create_project` to `false`.
    1. `azure_devops_authentication_scheme`: Enter the authentication scheme that your pipeline will use to authenticate to Azure. `WorkloadIdentityFederation` uses OpenId Connect and is the recommended approach. `ManagedServiceIdentity` requires the deployment of self-hosted agents are part of the bootstrap setup.
    1. `use_self_hosted_agents`: This controls if you want to deploy self-hosted agents. If you are using `ManagedServiceIdentity` for `azure_devops_authentication_scheme`, then you will need to deploy self-hosted agents as part of the bootstrap, so this setting will have no effect. This will default to `true`.
    1. `use_private_networking`: This controls whether private networking is deployed for your self-hosted agents and storage account. This only applies if you have `use_self_hosted_agents` set to `true` or `azure_devops_authentication_scheme` is set to `ManagedServiceIdentity`. This defaults to `true`.
    1. `allow_storage_access_from_my_ip`: This controls whether to allow access to the storage account from your IP address. This is only needed for trouble shooting. This only applies if you have `use_private_networking` set to `true`. This defaults to `false`.
    1. `apply_approvers`: This is a list of service principal names (SPN) of people you wish to be in the group that approves apply of the Azure landing zone module. This is a comma-separated list like `abc@xyz.com,def@xyz.com,ghi@xyz.com`. You may need to check what the SPN is prior to filling this out as it can vary based on identity provider.
    1. `root_parent_management_group_display_name`: This is the name of the root management group that you applied permissions to in a previous step. This defaults to `Tenant Root Group`, but if your organization has changed it or you want to use a different management group you'll need to enter the new display name.
1. You will now see a green message telling you that the next section is specific to the starter module you choose. Navigate to the documentation for the relevant starter module to get details of the specific inputs.
1. Once you have entered the starter module input, you see that a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.

## Next Steps

Now head to [Phase 3][wiki_quick_start_phase_3].

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_starter_modules]:               %5BUser-Guide%5D-Starter-Modules "Wiki - Starter Modules"
[wiki_quick_start_phase_3]:           %5BUser-Guide%5D-Quick-Start-Phase-3 "Wiki - Quick Start - Phase 3"
