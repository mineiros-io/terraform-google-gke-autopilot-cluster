# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Networking

locals {
  vpc_name = "terraform-google-gke-autopilot-cluster-unit-complete"
  subnet = {
    name       = local.vpc_name
    cidr_range = "10.4.0.0/20"
    secondary_ip_ranges = {
      pods = {
        name       = "terraform-google-gke-autopilot-cluster-unit-complete-pods"
        cidr_range = "10.4.128.0/17"
      }
      services = {
        name       = "terraform-google-gke-autopilot-cluster-unit-complete-services"
        cidr_range = "10.4.112.0/20"
      }
    }
  }
}

module "vpc" {
  source = "github.com/mineiros-io/terraform-google-network-vpc?ref=v0.0.2"

  project                         = local.project_id
  name                            = local.vpc_name
  delete_default_routes_on_create = false
}

module "subnetwork" {
  source = "github.com/mineiros-io/terraform-google-network-subnet?ref=v0.0.2"

  network = module.vpc.vpc.self_link
  project = local.project_id

  subnets = [
    {
      name                     = local.subnet.name
      region                   = local.region
      ip_cidr_range            = local.subnet.cidr_range
      private_ip_google_access = true

      secondary_ip_ranges = [
        {
          range_name    = local.subnet.secondary_ip_ranges.pods.name
          ip_cidr_range = local.subnet.secondary_ip_ranges.pods.cidr_range
        },
        {
          range_name    = local.subnet.secondary_ip_ranges.services.name
          ip_cidr_range = local.subnet.secondary_ip_ranges.services.cidr_range
        }
      ]
    }
  ]
}

# module "router-nat" {
#   source = "github.com/mineiros-io/terraform-google-cloud-router?ref=v0.0.2"

#   name    = "terraform-google-gke-autopilot-cluster-unit-complete"
#   project = var.project
#   region  = var.region
#   network = module.vpc.vpc.self_link

#   nats = [{
#     name = "terraform-google-gke-autopilot-cluster-unit-complete"
#   }]
# }

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = true

  project = local.project_id

  # add all required arguments
  name        = "${local.test_name}-ip-allocation-policy"
  description = "A GKE cluster created as a Unit Test in https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster"
  network     = module.vpc.vpc.self_link
  subnetwork  = module.subnetwork.subnetworks["${local.region}/${local.subnet.name}"].self_link

  # add all optional arguments that create additional resources

  # add most/all other optional arguments

  # creates a regional cluster, for details please see https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters
  location = local.region

  min_master_version = "latest"

  master_ipv4_cidr_block = "10.4.96.0/28"
  networking_mode        = "VPC_NATIVE"

  ip_allocation_policy = {
    cluster_secondary_range_name  = local.subnet.secondary_ip_ranges.pods.name
    services_secondary_range_name = local.subnet.secondary_ip_ranges.services.name
  }

  rbac_security_identity_group = "gke-security-groups@mineiros.io"

  enable_kubernetes_alpha              = true
  enable_private_nodes                 = true
  enable_private_endpoint              = true
  enable_network_egress_metering       = true
  enable_resource_consumption_metering = true
  addon_horizontal_pod_autoscaling     = false
  addon_http_load_balancing            = false
  master_authorized_networks_config = {
    cidr_blocks = [
      {
        display_name = "Office"
        cidr_block   = "192.168.0.0/24"
      }
    ]
  }

  logging_enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  logging_service           = "logging.googleapis.com/kubernetes"
  monitoring_service        = "monitoring.googleapis.com/kubernetes"
  monitoring_config = {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]
    managed_prometheus = {
      enabled = true
    }
  }

  release_channel = "RAPID"

  maintenance_policy = {
    recurring_window = {
      start_time = "2022-01-01T00:00:00Z"
      end_time   = "2030-01-02T00:00:00Z"
      recurrence = "FREQ=DAILY"
    }
    maintenance_exclusions = [
      {
        exclusion_name = "batch job"
        start_time     = "2025-01-01T00:00:00Z"
        end_time       = "2025-01-02T00:00:00Z"
      },
      {
        exclusion_name = "holiday data load"
        start_time     = "2025-05-01T00:00:00Z"
        end_time       = "2025-05-02T00:00:00Z"
      }
    ]
  }

  resource_usage_export_bigquery_dataset_id = "random_id"

  private_ipv6_google_access = "INHERIT_FROM_SUBNETWORK"

  resource_labels = {
    foo = "bar"
  }

  node_pool_auto_config = {
    network_tags = {
      tags = ["foo", "bar"]
    }
  }

  module_timeouts = {
    google_container_cluster = {
      create = "40m"
      update = "45m"
      delete = "50m"
    }
  }

  module_depends_on = ["nothing"]
}

module "test2" {
  source = "../.."

  module_enabled = true

  project = local.project_id

  # add all required arguments
  name        = "${local.test_name}-cluster-ipv4-cidr"
  description = "A GKE cluster created as a Unit Test in https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster"
  network     = module.vpc.vpc.self_link
  subnetwork  = module.subnetwork.subnetworks["${local.region}/${local.subnet.name}"].self_link

  # add all optional arguments that create additional resources

  # add most/all other optional arguments

  # creates a regional cluster, for details please see https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters
  location = local.region

  min_master_version = "latest"

  master_ipv4_cidr_block = "10.4.96.0/28"
  networking_mode        = "VPC_NATIVE"

  cluster_ipv4_cidr            = local.subnet.secondary_ip_ranges.pods.cidr_range
  rbac_security_identity_group = "gke-security-groups@mineiros.io"

  enable_kubernetes_alpha              = false
  enable_private_nodes                 = true
  enable_private_endpoint              = true
  enable_network_egress_metering       = true
  enable_resource_consumption_metering = true
  master_authorized_networks_config = {
    cidr_blocks = [
      {
        display_name = "Office"
        cidr_block   = "192.168.0.0/24"
      }
    ]
  }

  logging_enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  logging_service           = "logging.googleapis.com/kubernetes"
  monitoring_service        = "monitoring.googleapis.com/kubernetes"
  monitoring_config = {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
    managed_prometheus = {
      enabled = false
    }
  }

  release_channel = "RAPID"

  maintenance_policy = {
    recurring_window = {
      start_time = "2022-01-01T00:00:00Z"
      end_time   = "2030-01-02T00:00:00Z"
      recurrence = "FREQ=DAILY"
    }
    maintenance_exclusions = [
      {
        exclusion_name = "batch job"
        start_time     = "2025-01-01T00:00:00Z"
        end_time       = "2025-01-02T00:00:00Z"
      },
      {
        exclusion_name = "holiday data load"
        start_time     = "2025-05-01T00:00:00Z"
        end_time       = "2025-05-02T00:00:00Z"
      }
    ]
  }

  resource_usage_export_bigquery_dataset_id = "random_id"

  private_ipv6_google_access = "INHERIT_FROM_SUBNETWORK"

  resource_labels = {
    foo = "bar"
  }

  node_pool_auto_config = {
    network_tags = {
      tags = ["foo", "bar"]
    }
  }

  module_timeouts = {
    google_container_cluster = {
      create = "40m"
      update = "45m"
      delete = "50m"
    }
  }

  module_depends_on = ["nothing"]
}
