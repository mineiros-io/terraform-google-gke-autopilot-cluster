# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MINIMAL FEATURES UNIT TEST
# This module tests a minimal set of features.
# The purpose is to test all defaults for optional arguments and just provide the required arguments.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Networking

locals {
  vpc_name = "terraform-google-gke-autopilot-cluster-unit-minimal"
  subnet = {
    name       = local.vpc_name
    cidr_range = "10.4.0.0/20"
    secondary_ip_ranges = {
      pods = {
        name       = "terraform-google-gke-autopilot-cluster-unit-minimal-pods"
        cidr_range = "10.4.128.0/17"
      }
      services = {
        name       = "terraform-google-gke-autopilot-cluster-unit-minimal-services"
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
      name                     = local.vpc_name
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
# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  name       = local.test_name
  location   = local.region
  network    = module.vpc.vpc.self_link
  subnetwork = module.subnetwork.subnetworks["${local.region}/${local.subnet.name}"].self_link

  networking_mode        = "VPC_NATIVE"
  master_ipv4_cidr_block = "10.4.96.0/28"
  ip_allocation_policy = {
    cluster_secondary_range_name  = local.subnet.secondary_ip_ranges.pods.name
    services_secondary_range_name = local.subnet.secondary_ip_ranges.services.name
  }
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
