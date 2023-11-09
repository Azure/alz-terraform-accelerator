variable "azure_location" {
  type = string
}

variable "user_assigned_managed_identities" {
  type = map(string)
}

variable "federated_credentials" {
  type = map(object({
    federated_credential_subject = string
    federated_credential_issuer  = string
    federated_credential_name    = string
  }))
}

variable "create_federated_credential" {
  type    = bool
  default = true
}

variable "create_agents_resource_group" {
  type    = bool
  default = false
}

variable "resource_group_identity_name" {
  type = string
}

variable "resource_group_agents_name" {
  type    = string
  default = ""
}

variable "resource_group_state_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "create_agents" {
  type    = bool
  default = false
}

variable "agent_container_instances" {
  type = map(object({
    container_instance_name = string
    agent_name              = string
    managed_identity_key    = string
    agent_pool_name         = string
  }))
  default = {}
}

variable "agent_container_instance_image" {
  type    = string
  default = ""
}

variable "agent_organization_url" {
  type    = string
  default = ""
}

variable "agent_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "target_subscriptions" {
  type = list(string)
}

variable "root_management_group_display_name" {
  description = "The root management group display name"
  type        = string
}

variable "resource_providers" {
  type        = set(string)
  description = "The resource providers to register"
  nullable    = false
  default = [
    "Microsoft.ApiManagement",
    "Microsoft.AppPlatform",
    "Microsoft.Authorization",
    "Microsoft.Automation",
    "Microsoft.AVS",
    "Microsoft.Blueprint",
    "Microsoft.BotService",
    "Microsoft.Cache",
    "Microsoft.Cdn",
    "Microsoft.CognitiveServices",
    "Microsoft.Compute",
    "Microsoft.ContainerInstance",
    "Microsoft.ContainerRegistry",
    "Microsoft.ContainerService",
    "Microsoft.CostManagement",
    "Microsoft.CustomProviders",
    "Microsoft.Databricks",
    "Microsoft.DataLakeAnalytics",
    "Microsoft.DataLakeStore",
    "Microsoft.DataMigration",
    "Microsoft.DataProtection",
    "Microsoft.DBforMariaDB",
    "Microsoft.DBforMySQL",
    "Microsoft.DBforPostgreSQL",
    "Microsoft.DesktopVirtualization",
    "Microsoft.Devices",
    "Microsoft.DevTestLab",
    "Microsoft.DocumentDB",
    "Microsoft.EventGrid",
    "Microsoft.EventHub",
    "Microsoft.HDInsight",
    "Microsoft.HealthcareApis",
    "Microsoft.GuestConfiguration",
    "Microsoft.KeyVault",
    "Microsoft.Kusto",
    "microsoft.insights",
    "Microsoft.Logic",
    "Microsoft.MachineLearningServices",
    "Microsoft.Maintenance",
    "Microsoft.ManagedIdentity",
    "Microsoft.ManagedServices",
    "Microsoft.Management",
    "Microsoft.Maps",
    "Microsoft.MarketplaceOrdering",
    "Microsoft.Media",
    "Microsoft.MixedReality",
    "Microsoft.Network",
    "Microsoft.NotificationHubs",
    "Microsoft.OperationalInsights",
    "Microsoft.OperationsManagement",
    "Microsoft.PolicyInsights",
    "Microsoft.PowerBIDedicated",
    "Microsoft.Relay",
    "Microsoft.RecoveryServices",
    "Microsoft.Resources",
    "Microsoft.Search",
    "Microsoft.Security",
    "Microsoft.SecurityInsights",
    "Microsoft.ServiceBus",
    "Microsoft.ServiceFabric",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.StreamAnalytics",
    "Microsoft.TimeSeriesInsights",
    "Microsoft.Web"
  ]
}
