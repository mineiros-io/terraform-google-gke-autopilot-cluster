[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-gke-autopilot-cluster)

[![Build Status](https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-autopilot-cluster.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-gke-autopilot-cluster

A [Terraform](https://www.terraform.io) module to create and manage a Google
Kubernetes Engine (GKE) cluster with autopilot enabled.

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider Beta version ~> 4.34**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_container_cluster`

**Note:** This module comes without support for the default node pool
or its autoscaling since it can't be managed properly with Terraform.
Please use our [terraform-google-gke-node-pool](https://github.com/mineiros-io/terraform-google-gke-node-pool)
module instead for deploying and managing node groups for your clusters.

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-gke-autopilot-cluster" {
  source = "git@github.com:mineiros-io/terraform-google-gke-autopilot-cluster.git?ref=v0.0.4"

  name       = "gke-example"
  network    = "vpc_self_link"
  subnetwork = "subnetwork_self_link"

  master_ipv4_cidr_block = "10.4.96.0/28"

  ip_allocation_policy = {
    cluster_secondary_range_name  = "pod_range_name"
    services_secondary_range_name = "services_range_name"
  }
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of the cluster.

- [**`location`**](#var-location): *(Optional `string`)*<a name="var-location"></a>

  The location region in which the cluster master will be
  created. Please note that autopilot only supports
  [regional clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters).

- [**`network`**](#var-network): *(Optional `string`)*<a name="var-network"></a>

  The name or `self_link` of the Google Compute Engine network to which
  the cluster is connected.

  **Note:** For Shared VPC, set this to the self link of the shared network.

- [**`subnetwork`**](#var-subnetwork): *(Optional `string`)*<a name="var-subnetwork"></a>

  The name or `self_link` of the Google Compute Engine subnetwork in
  which the cluster's instances are launched.

- [**`networking_mode`**](#var-networking_mode): *(Optional `string`)*<a name="var-networking_mode"></a>

  Determines whether alias IPs or routes will be used for pod IPs in
  the cluster.

  Options are `VPC_NATIVE` or `ROUTES`. `VPC_NATIVE`
  enables IP aliasing, and requires the `ip_allocation_policy` block to
  be defined.

  Using a VPC-native cluster is the recommended approach by Google.
  For an overview of benefits of VPC-native clusters, please see https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#benefits

  Default is `"VPC_NATIVE"`.

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs.
  If it is not set, the provider project is used.

- [**`rbac_security_identity_group`**](#var-rbac_security_identity_group): *(Optional `string`)*<a name="var-rbac_security_identity_group"></a>

  The name of the RBAC security identity group for use with Google
  security groups in Kubernetes RBAC. Group name must be in format
  `gke-security-groups@yourdomain.com`.
  For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/google-groups-rbac

- [**`min_master_version`**](#var-min_master_version): *(Optional `string`)*<a name="var-min_master_version"></a>

  The minimum version of the Kubernetes master.
  GKE will auto-update the master to new versions, so this does not
  guarantee the current master version uses the read-only
  `master_version` field to obtain that.
  If unset, the cluster's version will be set by GKE to the version of
  the most recent official release.

- [**`cluster_ipv4_cidr`**](#var-cluster_ipv4_cidr): *(Optional `string`)*<a name="var-cluster_ipv4_cidr"></a>

  The IP address range of the Kubernetes pods in this cluster in CIDR
  notation (e.g. `10.96.0.0/14`). Leave blank to have one automatically
  chosen or specify a `/14` block in `10.0.0.0/8`.

  **Note:** This field will only work for routes-based clusters, where
  `ip_allocation_policy` is not defined.

- [**`enable_kubernetes_alpha`**](#var-enable_kubernetes_alpha): *(Optional `bool`)*<a name="var-enable_kubernetes_alpha"></a>

  Whether to enable Kubernetes Alpha features for this cluster.
  Note that when this option is enabled, the cluster cannot be upgraded
  and will be automatically deleted after 30 days.

  Default is `false`.

- [**`addon_horizontal_pod_autoscaling`**](#var-addon_horizontal_pod_autoscaling): *(Optional `bool`)*<a name="var-addon_horizontal_pod_autoscaling"></a>

  Whether to enable the horizontal pod autoscaling addon.

  Default is `true`.

- [**`addon_http_load_balancing`**](#var-addon_http_load_balancing): *(Optional `bool`)*<a name="var-addon_http_load_balancing"></a>

  Whether to enable the httpload balancer addon.

  Default is `true`.

- [**`ip_allocation_policy`**](#var-ip_allocation_policy): *(Optional `object(ip_allocation_policy)`)*<a name="var-ip_allocation_policy"></a>

  Configuration of cluster IP allocation for VPC-native clusters.

  **Note:** This field will only work for VPC-native clusters.

  Example:

  ```hcl
  readme_example = {
    cluster_ipv4_cidr_block  = "10.4.128.0/17"
    services_ipv4_cidr_block = "10.4.112.0/20"
  }
  ```

  The `ip_allocation_policy` object accepts the following attributes:

  - [**`cluster_ipv4_cidr_block`**](#attr-ip_allocation_policy-cluster_ipv4_cidr_block): *(Optional `string`)*<a name="attr-ip_allocation_policy-cluster_ipv4_cidr_block"></a>

    The IP address range for the cluster pod IPs.
    Set to blank to have a range chosen with the default size.
    Set to /netmask (e.g. `/14`) to have a range chosen with a specific netmask.
    Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918
    private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
    to pick a specific range to use.
    Conflicts with `cluster_secondary_range_name`.

  - [**`services_ipv4_cidr_block`**](#attr-ip_allocation_policy-services_ipv4_cidr_block): *(Optional `string`)*<a name="attr-ip_allocation_policy-services_ipv4_cidr_block"></a>

    The IP address range of the services IPs in this cluster.
    Set to blank to have a range chosen with the default size.
    Set to /netmask (e.g. `/14`) to have a range chosen with a specific
    netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the
    RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
    to pick a specific range to use.
    Conflicts with `cluster_secondary_range_name`.

  - [**`cluster_secondary_range_name`**](#attr-ip_allocation_policy-cluster_secondary_range_name): *(Optional `string`)*<a name="attr-ip_allocation_policy-cluster_secondary_range_name"></a>

    The name of the existing secondary range in the cluster's subnetwork
    to use for pod IP addresses. Alternatively, `cluster_ipv4_cidr_block`
    can be used to automatically create a GKE-managed one.
    Conflicts with `cluster_ipv4_cidr_block`.

  - [**`services_secondary_range_name`**](#attr-ip_allocation_policy-services_secondary_range_name): *(Optional `string`)*<a name="attr-ip_allocation_policy-services_secondary_range_name"></a>

    The name of the existing secondary range in the cluster's subnetwork
    to use for service `ClusterIPs`. Alternatively, `services_ipv4_cidr_block`
    can be used to automatically create a GKE-managed one.
    Conflicts with `services_ipv4_cidr_block`.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  The description of the cluster.

  Default is `""`.

- [**`master_authorized_networks_config`**](#var-master_authorized_networks_config): *(Optional `object(master_authorized_networks_config)`)*<a name="var-master_authorized_networks_config"></a>

  Configuration for handling external access control plane of the cluster.

  Example:

  ```hcl
  master_authorized_networks_config = {
    cidr_blocks = [
      {
        display_name = "Berlin Office"
        cidr_block   = "10.4.112.0/20"
      }
    ]
  }
  ```

  The `master_authorized_networks_config` object accepts the following attributes:

  - [**`cidr_blocks`**](#attr-master_authorized_networks_config-cidr_blocks): *(Optional `list(cidr_block)`)*<a name="attr-master_authorized_networks_config-cidr_blocks"></a>

    Set of master authorized networks. If none are provided, disallow
    external access (except the cluster node IPs, which GKE automatically
    whitelists).

    Default is `[]`.

    Each `cidr_block` object in the list accepts the following attributes:

    - [**`cidr_block`**](#attr-master_authorized_networks_config-cidr_blocks-cidr_block): *(**Required** `string`)*<a name="attr-master_authorized_networks_config-cidr_blocks-cidr_block"></a>

      External network that can access Kubernetes master through HTTPS.
      Must be specified in CIDR notation.

    - [**`display_name`**](#attr-master_authorized_networks_config-cidr_blocks-display_name): *(Optional `string`)*<a name="attr-master_authorized_networks_config-cidr_blocks-display_name"></a>

      Field for users to identify CIDR blocks.

- [**`maintenance_policy`**](#var-maintenance_policy): *(Optional `object(maintenance_policy)`)*<a name="var-maintenance_policy"></a>

  The maintenance windows and maintenance exclusions, which provide
  control over when cluster maintenance such as auto-upgrades can and
  cannot occur on your cluster.

  For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions

  The `maintenance_policy` object accepts the following attributes:

  - [**`daily_maintenance_window`**](#attr-maintenance_policy-daily_maintenance_window): *(Optional `object(daily_maintenance_window)`)*<a name="attr-maintenance_policy-daily_maintenance_window"></a>

    Time window specified for daily maintenance operations.

    For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#daily_maintenance_window

    Example:

    ```hcl
    maintenance_policy = {
      daily_maintenance_window = {
        start_time = "03:00"
      }
    }
    ```

    The `daily_maintenance_window` object accepts the following attributes:

    - [**`start_time`**](#attr-maintenance_policy-daily_maintenance_window-start_time): *(**Required** `string`)*<a name="attr-maintenance_policy-daily_maintenance_window-start_time"></a>

      Specify the `start_time` for a daily maintenance window in
      RFC3339 format `HH:MM`, where HH : [00-23] and MM : [00-59] GMT.

  - [**`recurring_window`**](#attr-maintenance_policy-recurring_window): *(Optional `object(recurring_window)`)*<a name="attr-maintenance_policy-recurring_window"></a>

    Time window specified for recurring maintenance operations.

    For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#recurring_window

    Example:

    ```hcl
    maintenance_policy = {
      recurring_window = {
        start_time = "2022-01-01T09:00:00Z"
        end_time   = "2022-01-01T17:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
      }
    }
    ```

    The `recurring_window` object accepts the following attributes:

    - [**`start_time`**](#attr-maintenance_policy-recurring_window-start_time): *(**Required** `string`)*<a name="attr-maintenance_policy-recurring_window-start_time"></a>

      Specify `start_time` and in RFC3339 "Zulu" date format.
      The start time's date is the initial date that the window starts.

    - [**`end_time`**](#attr-maintenance_policy-recurring_window-end_time): *(**Required** `string`)*<a name="attr-maintenance_policy-recurring_window-end_time"></a>

      Specify `end_time` in RFC3339 "Zulu" date format.
      The end time is used for calculating duration.

    - [**`recurrence`**](#attr-maintenance_policy-recurring_window-recurrence): *(**Required** `string`)*<a name="attr-maintenance_policy-recurring_window-recurrence"></a>

      Specify recurrence in [RFC5545](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.5.3)
      RRULE format, to specify when this maintenance window recurs.

  - [**`maintenance_exclusion`**](#attr-maintenance_policy-maintenance_exclusion): *(Optional `list(maintenance_exclusion)`)*<a name="attr-maintenance_policy-maintenance_exclusion"></a>

    Exceptions to maintenance window. Non-emergency maintenance should
    not occur in these windows. A cluster can have up to three
    maintenance exclusions at a time.

    For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions

    Example:

    ```hcl
    maintenance_policy = {
      recurring_window = {
        start_time = "2022-01-01T00:00:00Z"
        end_time   = "2022-01-02T00:00:00Z"
        recurrence = "FREQ=DAILY"
      }
      maintenance_exclusion = {
        exclusion_name = "batch job"
        start_time     = "2022-01-01T00:00:00Z"
        end_time       = "2022-01-02T00:00:00Z"
      }
      maintenance_exclusion = {
        exclusion_name = "holiday data load"
        start_time     = "2022-05-01T00:00:00Z"
        end_time       = "2022-05-02T00:00:00Z"
      }
    }
    ```

    Each `maintenance_exclusion` object in the list accepts the following attributes:

    - [**`exclusion_name`**](#attr-maintenance_policy-maintenance_exclusion-exclusion_name): *(**Required** `string`)*<a name="attr-maintenance_policy-maintenance_exclusion-exclusion_name"></a>

      The name of the maintenance exclusion window.

    - [**`start_time`**](#attr-maintenance_policy-maintenance_exclusion-start_time): *(**Required** `string`)*<a name="attr-maintenance_policy-maintenance_exclusion-start_time"></a>

      Specify `start_time` and in RFC3339 "Zulu" date format.
      The start time's date is the initial date that the window starts.

    - [**`end_time`**](#attr-maintenance_policy-maintenance_exclusion-end_time): *(**Required** `string`)*<a name="attr-maintenance_policy-maintenance_exclusion-end_time"></a>

      Specify `end_time` in RFC3339 "Zulu" date format.
      The end time is used for calculating duration.

- [**`resource_usage_export_bigquery_dataset_id`**](#var-resource_usage_export_bigquery_dataset_id): *(Optional `string`)*<a name="var-resource_usage_export_bigquery_dataset_id"></a>

  The ID of a BigQuery Dataset for using BigQuery as the destination of
  resource usage export. Needs to be configured when using egress metering
  and/or resource consumption metering.

- [**`enable_network_egress_metering`**](#var-enable_network_egress_metering): *(Optional `bool`)*<a name="var-enable_network_egress_metering"></a>

  Whether to enable network egress metering for this cluster. If
  enabled, a daemonset will be created in the cluster to meter network
  egress traffic. When enabling the network egress metering, a BigQuery
  Dataset needs to be configured as the destination using the
  `resource_usage_export_bigquery_dataset_id` variable.

  **Note:** You cannot use Shared VPCs or VPC peering with network egress metering.

  For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering

  Default is `false`.

- [**`enable_resource_consumption_metering`**](#var-enable_resource_consumption_metering): *(Optional `bool`)*<a name="var-enable_resource_consumption_metering"></a>

  Whether to enable resource consumption metering on this cluster. When
  enabled, a table will be created in the resource export BigQuery
  dataset that needs to be configured in `resource_usage_export_bigquery_dataset_id`
  to store resource consumption data. The resulting table can be
  joined with the resource usage table or with BigQuery billing export.

  For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering

  Default is `true`.

- [**`logging_enable_components`**](#var-logging_enable_components): *(Optional `set(string)`)*<a name="var-logging_enable_components"></a>

  A list of GKE components exposing logs.
  Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.

- [**`logging_service`**](#var-logging_service): *(Optional `string`)*<a name="var-logging_service"></a>

  The logging service that the cluster should write logs to. Available
  options include `logging.googleapis.com`, and `none`.

  Default is `"logging.googleapis.com/kubernetes"`.

- [**`monitoring_enable_components`**](#var-monitoring_enable_components): *(Optional `set(string)`)*<a name="var-monitoring_enable_components"></a>

  A list of GKE components exposing logs.
  Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.

- [**`monitoring_service`**](#var-monitoring_service): *(Optional `string`)*<a name="var-monitoring_service"></a>

  The monitoring service that the cluster should write metrics to.
  Automatically send metrics from pods in the cluster to the Google
  Cloud Monitoring API. VM metrics will be collected by Google Comput
  Engine regardless of this setting Available options include
  `monitoring.googleapis.com`, and `none`.

  Default is `"monitoring.googleapis.com/kubernetes"`.

- [**`resource_labels`**](#var-resource_labels): *(Optional `map(string)`)*<a name="var-resource_labels"></a>

  The GCE resource labels (a map of key/value pairs) to be applied to
  the cluster.

  For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/creating-managing-labels

  Default is `{}`.

- [**`enable_private_endpoint`**](#var-enable_private_endpoint): *(Optional `bool`)*<a name="var-enable_private_endpoint"></a>

  Whether the master's internal IP address is used as the cluster endpoint.

  Default is `false`.

- [**`enable_private_nodes`**](#var-enable_private_nodes): *(Optional `bool`)*<a name="var-enable_private_nodes"></a>

  Whether nodes have internal IP addresses only.

  Default is `true`.

- [**`private_ipv6_google_access`**](#var-private_ipv6_google_access): *(Optional `string`)*<a name="var-private_ipv6_google_access"></a>

  Configures the IPv6 connectivity to Google Services.
  By default, no private IPv6 access to or from Google Services is
  enabled (all access will be via IPv4).
  Accepted values are `PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED`,
  `INHERIT_FROM_SUBNETWORK`, `OUTBOUND`, and `BIDIRECTIONAL`.

- [**`master_ipv4_cidr_block`**](#var-master_ipv4_cidr_block): *(Optional `string`)*<a name="var-master_ipv4_cidr_block"></a>

  The IP range in CIDR notation to use for the hosted master network.

- [**`database_encryption_key_name`**](#var-database_encryption_key_name): *(Optional `string`)*<a name="var-database_encryption_key_name"></a>

  The name of a CloudKMS key to enable application-layer secrets
  encryption settings. If non-null the state will be set to:
  `ENCRYPTED` else `DECRYPTED`.

- [**`release_channel`**](#var-release_channel): *(Optional `string`)*<a name="var-release_channel"></a>

  The release channel of this cluster. Accepted values are
  `RAPID`, `REGULAR` and `STABLE`.

  Default is `"STABLE"`.

- [**`node_pool_auto_config`**](#var-node_pool_auto_config): *(Optional `object(node_pool_auto_config)`)*<a name="var-node_pool_auto_config"></a>

  Node pool configs that apply to auto-provisioned node pools
  in autopilot clusters and node auto-provisioning-enabled clusters.

  Default is `null`.

  Example:

  ```hcl
  node_pool_auto_config = {
    network_tags = {
      tags = ["foo", "bar"]
    }
  }
  ```

  The `node_pool_auto_config` object accepts the following attributes:

  - [**`network_tags`**](#attr-node_pool_auto_config-network_tags): *(Optional `object(network_tags)`)*<a name="attr-node_pool_auto_config-network_tags"></a>

    Configures network tags on cluster

    The `network_tags` object accepts the following attributes:

    - [**`tags`**](#attr-node_pool_auto_config-network_tags-tags): *(Optional `list(string)`)*<a name="attr-node_pool_auto_config-network_tags-tags"></a>

      List of tags to apply for all nodes managed by autopilot

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `google_container_cluster`, ...

  Example:

  ```hcl
  module_timeouts = {
    google_container_cluster = {
      create = "60m"
      update = "60m"
      delete = "60m"
    }
  }
  ```

  Each `timeout` object in the map accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`name`**](#output-name): *(`string`)*<a name="output-name"></a>

  The name of the cluster.

- [**`cluster`**](#output-cluster): *(`object(cluster)`)*<a name="output-cluster"></a>

  All arguments in `google_container_cluster`.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### Google Documentation

- https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture

### Terraform GCP Provider Documentation

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_cluster_autoscaling

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-gke-autopilot-cluster
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/issues
[license]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/CONTRIBUTING.md
