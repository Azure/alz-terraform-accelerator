locals {
  authentication_scheme_managed_identity = "ManagedIdentity"
  authentication_scheme_workload_identity_federation = "WorkloadIdentityFederation"
  is_authentication_scheme_managed_identity = var.authentication_scheme == local.authentication_scheme_managed_identity
  is_authentication_scheme_workload_identity_federation = var.authentication_scheme == local.authentication_scheme_workload_identity_federation
}