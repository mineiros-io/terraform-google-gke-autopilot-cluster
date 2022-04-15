data "google_project" "project" {}

locals {
  project = var.project != null ? var.project : data.google_project.project.project_id
}

resource "google_container_cluster" "cluster" {
  count = var.module_enabled ? 1 : 0

  project = local.project

  enable_autopilot = true

  network    = var.network
  subnetwork = var.subnetwork

  name            = var.name
  description     = var.description
  resource_labels = var.resource_labels

  location = var.location

  networking_mode            = var.networking_mode
  private_ipv6_google_access = var.private_ipv6_google_access

  enable_kubernetes_alpha = var.enable_kubernetes_alpha
  enable_tpu              = false
  enable_legacy_abac      = false

  # TODO: use data source to allow fuzzy version specification
  min_master_version = var.min_master_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  cluster_ipv4_cidr = var.cluster_ipv4_cidr

  dynamic "authenticator_groups_config" {
    for_each = var.rbac_security_identity_group != null ? [1] : []

    content {
      security_group = var.rbac_security_identity_group
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [1] : []

    content {
      channel = var.release_channel
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_enable_components != null ? [1] : []

    content {
      enable_components = var.logging_enable_components
    }
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_enable_components != null ? [1] : []

    content {
      enable_components = var.monitoring_enable_components
    }
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  # --------------------------------------------------------------------------------------------------------------------
  # MASTER AUTHORIZED NETWORKS
  # From the documentation:
  #  - The desired configuration options for master authorized networks.
  #  - Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists).
  #
  #  - null                              => no access limitation ? (TODO: verify this)
  #  - []                                => disallow external access (default)
  #  - [{cidr_block, display_name}, ...] => whitelist specific cidr_blocks
  # --------------------------------------------------------------------------------------------------------------------

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config != null ? [1] : []

    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks_config.cidr_blocks

        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = try(cidr_blocks.value.display_name, null)
        }
      }
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # Configuration for addons supported by GKE
  # --------------------------------------------------------------------------------------------------------------------

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # VPC_NATIVE configuration
  # --------------------------------------------------------------------------------------------------------------------

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []

    content {
      cluster_ipv4_cidr_block       = try(ip_allocation_policy.value.cluster_ipv4_cidr_block, null)
      services_ipv4_cidr_block      = try(ip_allocation_policy.value.services_ipv4_cidr_block, null)
      cluster_secondary_range_name  = try(ip_allocation_policy.value.cluster_secondary_range_name, null)
      services_secondary_range_name = try(ip_allocation_policy.value.services_secondary_range_name, null)
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []

    content {
      dynamic "daily_maintenance_window" {
        for_each = try([maintenance_policy.value.daily_maintenance_window], [])

        content {
          start_time = daily_maintenance_window.value.start_time
        }
      }

      dynamic "recurring_window" {
        for_each = try([maintenance_policy.value.recurring_window], [])

        content {
          start_time = recurring_window.value.start_time
          end_time   = recurring_window.value.end_time
          recurrence = recurring_window.value.recurrence
        }
      }

      dynamic "maintenance_exclusion" {
        for_each = try(maintenance_policy.value.maintenance_exclusions, [])

        content {
          exclusion_name = maintenance_exclusion.value.exclusion_name
          start_time     = maintenance_exclusion.value.start_time
          end_time       = maintenance_exclusion.value.end_time
        }
      }
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # Resource usage export to Bigquery
  # --------------------------------------------------------------------------------------------------------------------

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_bigquery_dataset_id != null ? [1] : []

    content {
      enable_network_egress_metering       = var.enable_network_egress_metering
      enable_resource_consumption_metering = var.enable_resource_consumption_metering

      bigquery_destination {
        dataset_id = var.resource_usage_export_bigquery_dataset_id
      }
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # PRIVATE CLUSTER CONFIG
  # From the provider documentation:
  #   - The Google provider is unable to validate certain configurations of private_cluster_config,
  #      when enable_private_nodes is false.
  #   - It's recommended that you omit the block entirely if the field is not set to true.
  # --------------------------------------------------------------------------------------------------------------------

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [1] : []

    content {
      enable_private_endpoint = var.enable_private_endpoint
      enable_private_nodes    = var.enable_private_nodes
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }
  }

  # --------------------------------------------------------------------------------------------------------------------
  # Encryption-at-rest configuration
  # --------------------------------------------------------------------------------------------------------------------

  dynamic "database_encryption" {
    for_each = var.database_encryption_key_name != null ? [1] : []

    content {
      key_name = var.database_encryption_key_name
      state    = var.database_encryption_key_name != "" ? "ENCRYPTED" : "DECRYPTED"
    }
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count,
    ]
  }

  timeouts {
    create = try(var.module_timeouts.google_container_cluster.create, null)
    update = try(var.module_timeouts.google_container_cluster.update, null)
    delete = try(var.module_timeouts.google_container_cluster.delete, null)
  }

  depends_on = [var.module_depends_on]
}
