<!-- markdownlint-disable first-line-h1 -->

Although the accelerator is designed to be a one-time run, we have some rudimentary support for automatically upgrading to newer versions of the accelerator.

This upgrade path is specifically for customers using the accelerator who haven't updated the repositories it deploys. If you have updated the repositories post initial bootstrap, you will need to take an alternative approach to upgrading.

## Important Notes

- The upgrade process does not support the scenario where you have made any changes to the deployed bootstrap or starter modules via git or the VCS system. If you run the upgrade it will overwrite your changes or fail.
- The upgrade process does not support breaking changes to major version of bootstrap or starter modules. If there is a breaking change, it will likely result in a destroy and re-create as part of the Terraform plan for the deployment. In most cases this may not be a problem, but you should validate prior to accepting the plan.
- If changes are made to the starter module as part of the upgrade, you will have to disable brach protection rules in the VCS system in order the update to succeed. To do this, you will need to navigate to the branmc protection rules in the VCS system and disable them. The apply will see that they have been disabled and re-apply them for you automatically.

## Upgrade Process

If you want to upgrade to a newer version of the accelerator bootstrap and / or starter, you can follow the steps below.

> NOTE: Behind the scenes the upgrade process copies the Terraform state file and the last set of cacched variables you entered, it is not any more intelligent than that.

1. Run `Deploy-Accelerator`, targetting the same output folder you did for the previous version and optionally specifiy the version you wish to upgrade to.
    - For example if you want to upgrade to specific versions of the starter and bootstrap module, you could run:

    ```powershell
    Deploy-Accelerator -i "terraform" -b "alz_azuredevops" -o "./my-folder" -starterRelease "2.0.1" -bootstrapRelease "2.0.2"
    ```

    - If you want to upgrade to the latest versions of both, you would run:

    ```powershell
    Deploy-Accelerator -i "terraform" -b "alz_azuredevops" -o "./my-folder"
    ```

2. You will see a message that starts with `AUTOMATIC UPGRADE:`. This will explain which version you will be upgrading from and to. E.g. `AUTOMATIC UPGRADE: We found version v2.0.0 of the bootstrap module that has been previously run. You can upgrade from this version to the new version v2.0.2`
3. You will then be prompted to confirm the upgrade. Type `upgrade` and hit enter.
4. The module will then run the upgrade process and you will see a success message once it completes.
5. The module will now follow the standard process and will pick up on the cached variables or input files and prompt you to use them. Type `use` to use the cached inputs or hit enter to update them or use input files.
6. If the new version of the accelerator has any new variables, you will be prompted to enter those manually if you haven't supplied them in an input file.
7. The module will then run the Terraform `init` and `apply` and you will see a success message once it completes.

> NOTE: As per the important notes above. If the new version of the accelerator starter module has any changes to the files it creates, it may fail due to branch protection rules. If this happens, you will need to manually disable the branch protection rules and then re-run the `Deploy-Accelerator` command.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)
