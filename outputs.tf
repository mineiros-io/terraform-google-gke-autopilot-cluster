locals {
  # we need to get the name from the cluster id to create an implicit dependency
  # on the actual created cluster.
  # Just using the name here will not create this dependency as the name is known
  # in the planning phase of terraform.
  # node pools are created using the name only (no self_link, no id is working)
  name_from_id = try(element(reverse(split("/", google_container_cluster.cluster[0].id)), 0), null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

output "name" {
  description = "The name of the created cluster."
  value       = local.name_from_id
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ---------------------------------------------------------------------------------------------------------------------

output "cluster" {
  description = "All attributes of the created `google_container_cluster` resource."
  value       = try(google_container_cluster.cluster[0], null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether or not the module is enabled."
  value       = var.module_enabled
}
