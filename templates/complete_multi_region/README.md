# Azure Landing Zones Accelerator Starter Module for Terraform - Complete Multi-Region

## Contributing

### Run the local examples

Create a `terraform.tfvars` file in the root of the module directory with the following content, replacing the placeholders with the actual values:

```hcl
starter_locations            = ["uksouth", "ukwest"]
subscription_id_connectivity = "00000000-0000-0000-0000-000000000000"
subscription_id_identity     = "00000000-0000-0000-0000-000000000000"
subscription_id_management   = "00000000-0000-0000-0000-000000000000"
```

#### Hub and Spoke Virtual Networks Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/config-hub-and-spoke-virtual-networks-multi-region.tfvars
```

#### Virtual WAN Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/config-virtual-wan-multi-region.tfvars
```
