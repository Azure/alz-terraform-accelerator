<!-- markdownlint-disable first-line-h1 -->

Although the accelerator is designed to be a one-time run, we have some rudimentary support for upgrading to newer versions of the accelerator. In the future we will provide more robust support for upgrading, but for now these steps should work, but are not fully supported.

If you want to upgrade to a newer version of the accelerator bootstrap and / or starter, you can follow the steps below.

> NOTE: Behind the scenes the upgrade process copies the Terraform state file and the last set of variables you entered

1. Run `Deploy-Accelerator`, targetting the same output folder you did for the previous version and optionally specifiy the version you wish to upgrade to.
    - For example if you want to upgrade to specific versions of the starter and bootstrap module, you could run:

    ```powershell
    Deploy-Accelerator -i "terraform" -b "alz_azuredevops" -o "./my-folder" -starterRelease "2.0.1" -booststrapRelease "2.0.2"
    ```

    - If you want to upgrade to the latest versions of both, you would run:

    ```powershell
    Deploy-Accelerator -i "terraform" -b "alz_azuredevops" -o "./my-folder"
    ```

2. You will see a message that starts with `AUTOMATIC UPGRADE:`. This will explain which version you will be upgrading from and to. E.g. `AUTOMATIC UPGRADE: We found version v2.0.0 that has been previously run. You can upgrade from this version to the new version v2.0.2`
3. You will then be prompted to confirm the upgrade. Type `upgrade` and hit enter.
4. The module will then run the upgrade process and you will see a success message once it completes.
5. The module will now follow the standard process and will pick up on the existing variables and prompt you to use them. Type `use` and hit enter.
6. If the new version of the accelerator has any new variables, you will be prompted to enter those manually.
7. The module will then run the Terraform `init` and `apply` and you will see a success message once it completes.

> NOTE: If the new version of the accelerator bootstrap has any changes to the files it creates, it may fail due to branch protection rules. If this happens, you will need to manually disable the branch protection rules and then re-run the `Deploy-Accelerator` command.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)
