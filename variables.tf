# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Required) The name of the cluster."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defauls, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "network" {
  type        = string
  description = "(Optional) The name or 'self_link' of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network."
  default     = null
}

variable "subnetwork" {
  type        = string
  description = "(Optional) The name or 'self_link' of the Google Compute Engine subnetwork in which the cluster's instances are launched."
  default     = null
}

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resource belongs. If it is not set, the provider project is used."
  default     = null
}

variable "addon_horizontal_pod_autoscaling" {
  type        = bool
  description = "(Optional) Whether to enable the horizontal pod autoscaling addon."
  default     = true
}

variable "addon_http_load_balancing" {
  type        = bool
  description = "(Optional) Whether to enable the httpload balancer addon."
  default     = true
}

variable "addon_network_policy_config" {
  type        = bool
  description = "(Optional) Whether to enable the network policy addon."
  default     = false
}

variable "addon_filestore_csi_driver" {
  type        = bool
  description = "(Optional) Whether to enable the Filestore CSI driver addon, which allows the usage of filestore instance as volumes."
  default     = false
}

variable "location" {
  type        = string
  description = "(Optional) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as 'us-central1-a'), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
  default     = null
}

variable "cluster_ipv4_cidr" {
  type        = string
  description = "(Optional) The IP address range of the Kubernetes pods in this cluster in CIDR notation (e.g. `10.96.0.0/14`). Leave blank to have one automatically chosen or specify a `/14` block in `10.0.0.0/8`. This field will only work for routes-based clusters, where `ip_allocation_policy` is not defined."
  default     = null
}

variable "database_encryption_key_name" {
  type        = string
  description = "(Optional) The name of a CloudKMS key to enable application-layer secrets encryption settings. If non-null the state will be set to: ENCRYPTED else DECRYPTED."
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) The description of the cluster."
  default     = ""
}

variable "node_locations" {
  type        = set(string)
  description = "(Optional) A set of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If this is specified for a zonal cluster, omit the cluster's zone."
  default     = []
}

variable "default_max_pods_per_node" {
  type        = number
  description = "(Optional) The default maximum number of pods per node in this cluster. This doesn't work on routes-based clusters, clusters that don't have IP Aliasing enabled. For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr"
  default     = null
}

variable "enable_binary_authorization" {
  type        = bool
  description = "(Optional) Enable BinAuthZ Admission controller"
  default     = false
}

variable "enable_kubernetes_alpha" {
  type        = bool
  description = "(Optional) Whether to enable Kubernetes Alpha features for this cluster. Note that when this option is enabled, the cluster cannot be upgraded and will be automatically deleted after 30 days."
  default     = false
}

variable "enable_tpu" {
  type        = bool
  description = "(Optional) Whether to enable Cloud TPU resources in this cluster. For details please see https://cloud.google.com/tpu/docs/kubernetes-engine-setup"
  default     = false
}

variable "enable_legacy_abac" {
  type        = bool
  description = "(Optional) Whether the ABAC authorizer is enabled for this cluster. When enabled, identities in the system, including service accounts, nodes, and controllers, will have statically granted permissions beyond those provided by the RBAC configuration or IAM."
  default     = false
}

variable "enable_shielded_nodes" {
  type        = bool
  description = "(Optional) Enable Shielded Nodes features on all nodes in this cluster"
  default     = true
}

variable "ip_allocation_policy" {
  type = any
  # type = object({
  #   # (Optional) The IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. Set to /netmask (e.g. `/14`) to have a range chosen with a specific netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) to pick a specific range to use.
  #   cluster_ipv4_cidr_block = optional(string)
  #   # (Optional) The IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. Set to /netmask (e.g. `/14`) to have a range chosen with a specific netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) to pick a specific range to use.
  #   services_ipv4_cidr_block = optional(string)
  #   # (Optional) The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses. Alternatively, `cluster_ipv4_cidr_block` can be used to automatically create a GKE-managed one.
  #   cluster_secondary_range_name = optional(string)
  #   # (Optional) The name of the existing secondary range in the cluster's subnetwork to use for service `ClusterIPs`. Alternatively, `services_ipv4_cidr_block` can be used to automatically create a GKE-managed one.
  #   services_secondary_range_name = optional(string)
  # })
  description = "(Optional) Configuration of cluster IP allocation for VPC-native clusters. Adding this block enables IP aliasing, making the cluster VPC-native instead of routes-based."
  default     = null
}

variable "networking_mode" {
  type        = string
  description = "(Optional) Determines whether alias IPs or routes will be used for pod IPs in the cluster. Options are `VPC_NATIVE` or `ROUTES`. `VPC_NATIVE` enables IP aliasing, and requires the `ip_allocation_policy` block to be defined. By default when this field is unspecified."
  default     = "VPC_NATIVE"

  validation {
    condition     = can(regex("^VPC_NATIVE|ROUTES$", var.networking_mode))
    error_message = "The networking_mode variable must be either set to 'VPC_NATIVE' or 'ROUTES'."
  }
}

variable "logging_enable_components" {
  type        = set(string)
  description = "(Optional) A list of GKE components exposing logs. Supported values include: 'SYSTEM_COMPONENTS' and 'WORKLOADS'."
  default     = null

  validation {
    condition     = var.logging_enable_components != null ? alltrue([for c in var.logging_enable_components : can(regex("^SYSTEM_COMPONENTS|WORKLOADS$", c))]) : true
    error_message = "The logging_enable_components variable must be a list with the values 'SYSTEM_COMPONENTS' and/or 'WORKLOADS'."
  }
}

variable "logging_service" {
  type        = string
  description = "(Optional) The logging service that the cluster should write logs to. Available options include 'logging.googleapis.com', 'logging.googleapis.com/kubernetes' (beta), and 'none'"
  default     = "logging.googleapis.com/kubernetes"

  validation {
    condition     = var.logging_service != null ? can(regex("^(logging\\.googleapis\\.com(\\/kubernetes)?)$", var.logging_service)) : true
    error_message = "The logging_service variable must be either set to 'logging.googleapis.com' or 'logging.googleapis.com/kubernetes' (beta)."
  }
}

variable "monitoring_enable_components" {
  type        = set(string)
  description = "(Optional) A list of GKE components exposing logs. Supported values include: 'SYSTEM_COMPONENTS' and in beta provider, both 'SYSTEM_COMPONENTS' and 'WORKLOADS' are supported."
  default     = null

  validation {
    condition     = var.monitoring_enable_components != null ? alltrue([for c in var.monitoring_enable_components : can(regex("^SYSTEM_COMPONENTS|WORKLOADS$", c))]) : true
    error_message = "The monitoring_enable_components variable must be a list with the values 'SYSTEM_COMPONENTS' and/or 'WORKLOADS'."
  }
}

variable "monitoring_service" {
  type        = string
  description = "(Optional) The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include `monitoring.googleapis.com` (Legacy Stackdriver), `monitoring.googleapis.com/kubernetes` (Stackdriver Kubernetes Engine Monitoring), and `none`"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "maintenance_policy" {
  type = any
  # type = object({
  #   # (Optional) Daily maintenance window
  #   daily_maintenance_window = optional(object({
  #     # (Required) Specify the `start_time` in RFC3339 format `HH:MM`, where HH : [00-23] and MM : [00-59] GMT.
  #     start_time = string
  #   }))
  #   # (Optional) Time window for recurring maintenance operations.
  #   recurring_window = optional(object({
  #     # (Required) Specify `start_time` and in RFC3339 "Zulu" date format. The start time's date is the initial date that the window starts.
  #     start_time = string
  #     # (Required) Specify `end_time` in RFC3339 "Zulu" date format. The end time is used for calculating duration.
  #     end_time = string
  #     # (Required) Specify recurrence in RFC5545 RRULE format, to specify when this recurs.
  #     recurrence = string
  #   }))
  #   # (Optional) Exceptions to maintenance window. Non-emergency maintenance should not occur in these windows. A cluster can have up to three maintenance exclusions at a time. For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions
  #   maintenance_exclusions = optional(list(object({
  #     # (Required) The name of the maintenance exclusion window.
  #     exclusion_name = string
  #     # (Required) Specify `start_time` and in RFC3339 "Zulu" date format. The start time's date is the initial date that the window starts.
  #     start_time = string
  #     # (Required) Specify `end_time` in RFC3339 "Zulu" date format. The end time is used for calculating duration.
  #     end_time = string
  #   })))
  # })
  description = "(Optional) The maintenance policy to use for the cluster."
  default     = null
}

variable "network_policy" {
  type = any
  # type = object({
  #   # (Required) Whether network policy is enabled on the cluster.
  #   enabled = bool
  #   # (Optional) The selected network policy provider. Defaults to `CALICO`.
  #   provider = optional(string)
  # })
  description = "(Optional) Configuration options for the NetworkPolicy feature."
  default     = null
}

variable "rbac_security_identity_group" {
  description = "(Optional) The name of the RBAC security identity group for use with Google security groups in Kubernetes RBAC. Group name must be in format 'gke-security-groups@yourdomain.com'."
  type        = string
  default     = null
}

variable "min_master_version" {
  type        = string
  description = "(Optional) The minimum version of the master. GKE will auto-update the master to new versions, so this does not guarantee the current master version --use the read-only 'master_version' field to obtain that. If unset, the cluster's version will be set by GKE to the version of the most recent official release (which is not necessarily the latest version)."
  default     = null
}

variable "master_authorized_networks_config" {
  type = any
  # type = object({
  #   cidr_blocks = list(object({
  #     cidr_block   = string
  #     display_name = optional(string)
  #   }))
  # })
  description = "(Optional) The desired configuration options for master authorized networks. Omit the nested `cidr_blocks` attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = null
}

variable "enable_vertical_pod_autoscaling" {
  type        = bool
  description = "(Optional) If enabled, Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it."
  default     = false
}

variable "resource_usage_export_bigquery_dataset_id" {
  type        = string
  description = "(Optional) The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export."
  default     = null
}

variable "enable_network_egress_metering" {
  type        = bool
  description = "(Optional) Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
  default     = false
}

variable "enable_resource_consumption_metering" {
  type        = bool
  description = "(Optional) Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export."
  default     = true
}

variable "resource_labels" {
  type        = map(string)
  description = "(Optional) The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "enable_intranode_visibility" {
  type        = bool
  description = "(Optional) Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network."
  default     = false
}

variable "private_ipv6_google_access" {
  type        = string
  description = "(Optional) The desired state of IPv6 connectivity to Google Services. By default, no private IPv6 access to or from Google Services (all access will be via IPv4)."
  default     = null

  validation {
    condition     = var.private_ipv6_google_access != null ? can(regex("^PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED|INHERIT_FROM_SUBNETWORK|OUTBOUND|BIDIRECTIONAL$", var.private_ipv6_google_access)) : true
    error_message = "The private_ipv6_google_access variable must be either set to 'PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED', 'INHERIT_FROM_SUBNETWORK', 'OUTBOUND', or 'BIDIRECTIONAL'."
  }
}

variable "enable_private_endpoint" {
  type        = bool
  description = "(Optional) Whether the master's internal IP address is used as the cluster endpoint."
  default     = false
}

variable "enable_private_nodes" {
  type        = bool
  description = "(Optional) Whether nodes have internal IP addresses only."
  default     = true
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Required) The IP range in CIDR notation to use for the hosted master network"
  default     = null
}

variable "release_channel" {
  type        = string
  description = "(Optional) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "UNSPECIFIED"

  validation {
    condition     = var.release_channel != null ? can(regex("^UNSPECIFIED|RAPID|REGULAR|STABLE$", var.release_channel)) : true
    error_message = "The release_channel variable must be either set to 'UNSPECIFIED', 'RAPID', 'REGULAR' or 'STABLE'."
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not."
  default     = true
}

variable "module_timeouts" {
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  # type = object({
  #   google_container_cluster = optional(object({
  #     create = optional(string)
  #     update = optional(string)
  #     delete = optional(string)
  #   }))
  # })
  default = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on."
  default     = []
}
