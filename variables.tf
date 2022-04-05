# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

# variable "module_tags" {
#   type        = map(string)
#   description = "(Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be overwritten by resource-specific tags."
#   default     = {}
# }

# variable "module_timeouts" {
#   description = "(Optional) A map of timeout objects that is keyed by Terraform resource name defining timeouts for `create`, `update` and `delete` Terraform operations."
#   type        = any
#   default     = null
# }

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
