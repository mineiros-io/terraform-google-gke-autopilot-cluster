// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /test/terramate_google.tm.hcl

variable "gcp_project" {
  description = "(Required) The ID of the project in which the resource belongs."
  type        = string
}
variable "gcp_region" {
  default     = "europe-west3"
  description = "(Optional) The gcp region in which all resources will be created."
  type        = string
}
variable "gcp_org_domain" {
  default     = null
  description = "(Optional) The domain of the organization test projects should be created in."
  type        = string
}
variable "gcp_billing_account" {
  default     = null
  description = "(Optional) The billing account to use when creating projects."
  type        = string
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.34"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.34"
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
provider "random" {
}
resource "random_id" "suffix" {
  byte_length = 16
  count       = local.test_name != "unit-disabled" ? 1 : 0
}
data "google_project" "project" {
}
data "google_organization" "org" {
  count  = local.org_domain != null ? 1 : 0
  domain = local.org_domain
}
locals {
  billing_account = var.gcp_billing_account
  org_domain      = var.gcp_org_domain
  org_id          = try(data.google_organization.org[0].name, null)
  project_id      = var.gcp_project
  project_number  = data.google_project.project.number
  random_suffix   = try(random_id.suffix[0].hex, "disabled")
  region          = var.gcp_region
  test_name       = "unit-disabled"
}
