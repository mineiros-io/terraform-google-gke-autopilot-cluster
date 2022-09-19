globals {
  minimum_provider_version    = "4.34"
  provider_version_constraint = "~> ${global.minimum_provider_version}"

  stack_basename = tm_reverse(tm_split("/", terramate.path))[0]
}

generate_hcl "_generated_google.tf" {
  # condition = global.provider == "google"
  content {
    variable "gcp_project" {
      type        = string
      description = "(Required) The ID of the project in which the resource belongs."
    }

    variable "gcp_region" {
      type        = string
      description = "(Optional) The gcp region in which all resources will be created."
      default     = "europe-west3"
    }

    variable "gcp_org_domain" {
      type        = string
      description = "(Optional) The domain of the organization test projects should be created in."
      default     = null
    }

    variable "gcp_billing_account" {
      type        = string
      description = "(Optional) The billing account to use when creating projects."
      default     = null
    }

    terraform {
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = global.provider_version_constraint
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = global.provider_version_constraint
        }
        random = {
          source  = "hashicorp/random"
          version = "~> 3.1"
        }
      }
    }

    provider "google" {
      project = var.gcp_project
      region  = var.gcp_region
    }

    provider "google-beta" {
      project = var.gcp_project
      region  = var.gcp_region
    }

    provider "random" {}

    resource "random_id" "suffix" {
      count       = local.test_name != "unit-disabled" ? 1 : 0
      byte_length = 16
    }

    data "google_project" "project" {}

    data "google_organization" "org" {
      count = local.org_domain != null ? 1 : 0

      domain = local.org_domain
    }

    # define default locals for all tests
    locals {
      test_name       = global.stack_basename
      random_suffix   = try(random_id.suffix[0].hex, "disabled")
      project_id      = var.gcp_project
      project_number  = data.google_project.project.number
      org_domain      = var.gcp_org_domain
      org_id          = try(data.google_organization.org[0].name, null)
      billing_account = var.gcp_billing_account
      region          = var.gcp_region
    }
  }
}
