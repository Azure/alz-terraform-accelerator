locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = 30
          enable_monitoring_for_vm                          = true
          enable_monitoring_for_vmss                        = true
          enable_solution_for_agent_health_assessment       = true
          enable_solution_for_anti_malware                  = true
          enable_solution_for_change_tracking               = true
          enable_solution_for_service_map                   = false
          enable_solution_for_sql_assessment                = true
          enable_solution_for_sql_vulnerability_assessment  = true
          enable_solution_for_sql_advanced_threat_detection = true
          enable_solution_for_updates                       = true
          enable_solution_for_vm_insights                   = true
          enable_solution_for_container_insights            = true
          enable_sentinel                                   = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact                                = "security_contact@replace_me"
          enable_defender_for_apis                              = true
          enable_defender_for_app_services                      = true
          enable_defender_for_arm                               = true
          enable_defender_for_containers                        = true
          enable_defender_for_cosmosdbs                         = true
          enable_defender_for_cspm                              = true
          enable_defender_for_dns                               = true
          enable_defender_for_key_vault                         = true
          enable_defender_for_oss_databases                     = true
          enable_defender_for_servers                           = true
          enable_defender_for_servers_vulnerability_assessments = true
          enable_defender_for_sql_servers                       = true
          enable_defender_for_sql_server_vms                    = true
          enable_defender_for_storage                           = true
        }
      }
      location = ""
      tags     = {}
      advanced = {}
    }
  }

  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = null # Required argument 
            location                     = ""
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = false
              config = {
                address_prefix           = ""
                gateway_sku_expressroute = ""
                gateway_sku_vpn          = ""
                advanced_vpn_settings = {
                  enable_bgp                       = null
                  active_active                    = null
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
              azure_firewall = {
                enabled = false
                config = {
                  address_prefix            = ""
                  address_management_prefix = ""
                  enable_dns_proxy          = true
                  dns_servers               = []
                  sku_tier                  = "Standard"
                  base_policy_id            = ""
                  private_ip_ranges         = []
                  threat_intelligence_mode  = "Alert"
                  threat_intelligence_allow = []
                  availability_zones = {
                    zone_1 = true
                    zone_2 = true
                    zone_3 = true
                  }
                }
              }
              spoke_virtual_network_resource_ids      = []
              enable_outbound_virtual_network_peering = false
              enable_hub_network_mesh_peering         = false
            }
          }
        }
      ]
      vwan_hub_networks = [
        {
          enabled = true
          config = {
            address_prefix = null # Required argument 
            location       = null # Required argument 
            sku            = ""
            routes         = []
            expressroute_gateway = {
              enabled = false
              config = {
                scale_unit = 1
              }
            }
            vpn_gateway = {
              enabled = false
              config = {
                bgp_settings       = []
                routing_preference = "Microsoft Network"
                scale_unit         = 1
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                enable_dns_proxy          = true
                dns_servers               = []
                sku_tier                  = "Standard"
                base_policy_id            = ""
                private_ip_ranges         = []
                threat_intelligence_mode  = "Alert"
                threat_intelligence_allow = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids        = []
            secure_spoke_virtual_network_resource_ids = []
            enable_virtual_hub_connections            = false
          }
        }
      ]
      ddos_protection_plan = {
        enabled = false
        config = {
          location = ""
        }
      }
      dns = {
        enabled = true
        config = {
          location = ""
          enable_private_link_by_service = {
            azure_api_management                 = true
            azure_app_configuration_stores       = true
            azure_arc                            = true
            azure_automation_dscandhybridworker  = true
            azure_automation_webhook             = true
            azure_backup                         = true
            azure_batch_account                  = true
            azure_bot_service_bot                = true
            azure_bot_service_token              = true
            azure_cache_for_redis                = true
            azure_cache_for_redis_enterprise     = true
            azure_container_registry             = true
            azure_cosmos_db_cassandra            = true
            azure_cosmos_db_gremlin              = true
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_sql                  = true
            azure_cosmos_db_table                = true
            azure_data_explorer                  = true
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_data_health_data_services      = true
            azure_data_lake_file_system_gen2     = true
            azure_database_for_mariadb_server    = true
            azure_database_for_mysql_server      = true
            azure_database_for_postgresql_server = true
            azure_digital_twins                  = true
            azure_event_grid_domain              = true
            azure_event_grid_topic               = true
            azure_event_hubs_namespace           = true
            azure_file_sync                      = true
            azure_hdinsights                     = true
            azure_iot_dps                        = true
            azure_iot_hub                        = true
            azure_key_vault                      = true
            azure_key_vault_managed_hsm          = true
            azure_kubernetes_service_management  = true
            azure_machine_learning_workspace     = true
            azure_managed_disks                  = true
            azure_media_services                 = true
            azure_migrate                        = true
            azure_monitor                        = true
            azure_purview_account                = true
            azure_purview_studio                 = true
            azure_relay_namespace                = true
            azure_search_service                 = true
            azure_service_bus_namespace          = true
            azure_site_recovery                  = true
            azure_sql_database_sqlserver         = true
            azure_synapse_analytics_dev          = true
            azure_synapse_analytics_sql          = true
            azure_synapse_studio                 = true
            azure_web_apps_sites                 = true
            azure_web_apps_static_sites          = true
            cognitive_services_account           = true
            microsoft_power_bi                   = true
            signalr                              = true
            signalr_webpubsub                    = true
            storage_account_blob                 = true
            storage_account_file                 = true
            storage_account_queue                = true
            storage_account_table                = true
            storage_account_web                  = true
          }
          private_link_locations                                 = []
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }
    location = ""
    tags     = {}
    advanced = {}
  }

  configure_identity_resources = {
    settings = {
      identity = {
        enabled =  true
        config = {
          enable_deny_public_ip             =  true
          enable_deny_rdp_from_internet     =  true
          enable_deny_subnet_without_nsg    =  true
          enable_deploy_azure_backup_on_vms =  true
        }
      }
    }
  }
}
