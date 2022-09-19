header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-gke-autopilot-cluster"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-autopilot-cluster.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-gke-autopilot-cluster"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create and manage a Google
    Kubernetes Engine (GKE) cluster with autopilot enabled.

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider Beta version ~> 4.34**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `google_container_cluster`

      **Note:** This module comes without support for the default node pool
      or its autoscaling since it can't be managed properly with Terraform.
      Please use our [terraform-google-gke-node-pool](https://github.com/mineiros-io/terraform-google-gke-node-pool)
      module instead for deploying and managing node groups for your clusters.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-gke-autopilot-cluster" {
        source = "git@github.com:mineiros-io/terraform-google-gke-autopilot-cluster.git?ref=v0.0.3"

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
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          The name of the cluster.
        END
      }

      variable "location" {
        type        = string
        description = <<-END
          The location region in which the cluster master will be
          created. Please note that autopilot only supports
          [regional clusters](https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters).
        END
      }

      variable "network" {
        type        = string
        description = <<-END
          The name or `self_link` of the Google Compute Engine network to which
          the cluster is connected.

          **Note:** For Shared VPC, set this to the self link of the shared network.
        END
      }

      variable "subnetwork" {
        type        = string
        description = <<-END
          The name or `self_link` of the Google Compute Engine subnetwork in
          which the cluster's instances are launched.
        END
      }

      variable "networking_mode" {
        type        = string
        default     = "VPC_NATIVE"
        description = <<-END
          Determines whether alias IPs or routes will be used for pod IPs in
          the cluster.

          Options are `VPC_NATIVE` or `ROUTES`. `VPC_NATIVE`
          enables IP aliasing, and requires the `ip_allocation_policy` block to
          be defined.

          Using a VPC-native cluster is the recommended approach by Google.
          For an overview of benefits of VPC-native clusters, please see https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#benefits
        END
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs.
          If it is not set, the provider project is used.
        END
      }

      variable "rbac_security_identity_group" {
        type        = string
        description = <<-END
          The name of the RBAC security identity group for use with Google
          security groups in Kubernetes RBAC. Group name must be in format
          `gke-security-groups@yourdomain.com`.
          For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/google-groups-rbac
        END
      }

      variable "min_master_version" {
        type        = string
        description = <<-END
          The minimum version of the Kubernetes master.
          GKE will auto-update the master to new versions, so this does not
          guarantee the current master version uses the read-only
          `master_version` field to obtain that.
          If unset, the cluster's version will be set by GKE to the version of
          the most recent official release.
        END
      }

      variable "cluster_ipv4_cidr" {
        type        = string
        description = <<-END
          The IP address range of the Kubernetes pods in this cluster in CIDR
          notation (e.g. `10.96.0.0/14`). Leave blank to have one automatically
          chosen or specify a `/14` block in `10.0.0.0/8`.

          **Note:** This field will only work for routes-based clusters, where
          `ip_allocation_policy` is not defined.
        END
      }

      variable "enable_kubernetes_alpha" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable Kubernetes Alpha features for this cluster.
          Note that when this option is enabled, the cluster cannot be upgraded
          and will be automatically deleted after 30 days.
        END
      }

      variable "addon_horizontal_pod_autoscaling" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable the horizontal pod autoscaling addon.
        END
      }

      variable "addon_http_load_balancing" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable the httpload balancer addon.
        END
      }

      variable "ip_allocation_policy" {
        type           = object(ip_allocation_policy)
        description    = <<-END
          Configuration of cluster IP allocation for VPC-native clusters.

          **Note:** This field will only work for VPC-native clusters.
        END
        readme_example = <<-END
          readme_example = {
            cluster_ipv4_cidr_block  = "10.4.128.0/17"
            services_ipv4_cidr_block = "10.4.112.0/20"
          }
        END

        attribute "cluster_ipv4_cidr_block" {
          type        = string
          description = <<-END
            The IP address range for the cluster pod IPs.
            Set to blank to have a range chosen with the default size.
            Set to /netmask (e.g. `/14`) to have a range chosen with a specific netmask.
            Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918
            private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
            to pick a specific range to use.
            Conflicts with `cluster_secondary_range_name`.
          END
        }

        attribute "services_ipv4_cidr_block" {
          type        = string
          description = <<-END
            The IP address range of the services IPs in this cluster.
            Set to blank to have a range chosen with the default size.
            Set to /netmask (e.g. `/14`) to have a range chosen with a specific
            netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the
            RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
            to pick a specific range to use.
            Conflicts with `cluster_secondary_range_name`.
          END
        }

        attribute "cluster_secondary_range_name" {
          type        = string
          description = <<-END
            The name of the existing secondary range in the cluster's subnetwork
            to use for pod IP addresses. Alternatively, `cluster_ipv4_cidr_block`
            can be used to automatically create a GKE-managed one.
            Conflicts with `cluster_ipv4_cidr_block`.
          END
        }

        attribute "services_secondary_range_name" {
          type        = string
          description = <<-END
            The name of the existing secondary range in the cluster's subnetwork
            to use for service `ClusterIPs`. Alternatively, `services_ipv4_cidr_block`
            can be used to automatically create a GKE-managed one.
            Conflicts with `services_ipv4_cidr_block`.
          END
        }
      }

      variable "description" {
        type        = string
        default     = ""
        description = <<-END
          The description of the cluster.
        END
      }

      variable "master_authorized_networks_config" {
        type           = object(master_authorized_networks_config)
        description    = <<-END
          Configuration for handling external access control plane of the cluster.
        END
        readme_example = <<-END
          master_authorized_networks_config = {
            cidr_blocks = [
              {
                display_name = "Berlin Office"
                cidr_block   = "10.4.112.0/20"
              }
            ]
          }
        END

        attribute "cidr_blocks" {
          type        = list(cidr_block)
          default     = []
          description = <<-END
            Set of master authorized networks. If none are provided, disallow
            external access (except the cluster node IPs, which GKE automatically
            whitelists).
          END

          attribute "cidr_block" {
            required    = true
            type        = string
            description = <<-END
              External network that can access Kubernetes master through HTTPS.
              Must be specified in CIDR notation.
            END
          }

          attribute "display_name" {
            type        = string
            description = <<-END
              Field for users to identify CIDR blocks.
            END
          }
        }
      }

      variable "maintenance_policy" {
        type        = object(maintenance_policy)
        description = <<-END
          The maintenance windows and maintenance exclusions, which provide
          control over when cluster maintenance such as auto-upgrades can and
          cannot occur on your cluster.

          For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions
        END

        attribute "daily_maintenance_window" {
          type           = object(daily_maintenance_window)
          description    = <<-END
            Time window specified for daily maintenance operations.

            For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#daily_maintenance_window
          END
          readme_example = <<-END
            maintenance_policy = {
              daily_maintenance_window = {
                start_time = "03:00"
              }
            }
          END

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify the `start_time` for a daily maintenance window in
              RFC3339 format `HH:MM`, where HH : [00-23] and MM : [00-59] GMT.
            END
          }
        }

        attribute "recurring_window" {
          type           = object(recurring_window)
          description    = <<-END
            Time window specified for recurring maintenance operations.

            For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#recurring_window
          END
          readme_example = <<-END
            maintenance_policy = {
              recurring_window = {
                start_time = "2022-01-01T09:00:00Z"
                end_time   = "2022-01-01T17:00:00Z"
                recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
              }
            }
          END

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `start_time` and in RFC3339 "Zulu" date format.
              The start time's date is the initial date that the window starts.
            END
          }

          attribute "end_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `end_time` in RFC3339 "Zulu" date format.
              The end time is used for calculating duration.
            END
          }

          attribute "recurrence" {
            required    = true
            type        = string
            description = <<-END
              Specify recurrence in [RFC5545](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.5.3)
              RRULE format, to specify when this maintenance window recurs.
            END
          }
        }

        attribute "maintenance_exclusion" {
          type           = list(maintenance_exclusion)
          description    = <<-END
            Exceptions to maintenance window. Non-emergency maintenance should
            not occur in these windows. A cluster can have up to three
            maintenance exclusions at a time.

            For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions
          END
          readme_example = <<-END
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
          END

          attribute "exclusion_name" {
            required    = true
            type        = string
            description = <<-END
              The name of the maintenance exclusion window.
            END
          }

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `start_time` and in RFC3339 "Zulu" date format.
              The start time's date is the initial date that the window starts.
            END
          }

          attribute "end_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `end_time` in RFC3339 "Zulu" date format.
              The end time is used for calculating duration.
            END
          }
        }
      }

      variable "resource_usage_export_bigquery_dataset_id" {
        type        = string
        description = <<-END
          The ID of a BigQuery Dataset for using BigQuery as the destination of
          resource usage export. Needs to be configured when using egress metering
          and/or resource consumption metering.
        END
      }

      variable "enable_network_egress_metering" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable network egress metering for this cluster. If
          enabled, a daemonset will be created in the cluster to meter network
          egress traffic. When enabling the network egress metering, a BigQuery
          Dataset needs to be configured as the destination using the
          `resource_usage_export_bigquery_dataset_id` variable.

          **Note:** You cannot use Shared VPCs or VPC peering with network egress metering.

          For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering
        END
      }

      variable "enable_resource_consumption_metering" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable resource consumption metering on this cluster. When
          enabled, a table will be created in the resource export BigQuery
          dataset that needs to be configured in `resource_usage_export_bigquery_dataset_id`
          to store resource consumption data. The resulting table can be
          joined with the resource usage table or with BigQuery billing export.

          For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering
        END
      }

      variable "logging_enable_components" {
        type        = set(string)
        description = <<-END
          A list of GKE components exposing logs.
          Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.
        END
      }

      variable "logging_service" {
        type        = string
        default     = "logging.googleapis.com/kubernetes"
        description = <<-END
          The logging service that the cluster should write logs to. Available
          options include `logging.googleapis.com`, and `none`.
        END
      }

      variable "monitoring_enable_components" {
        type        = set(string)
        description = <<-END
          A list of GKE components exposing logs.
          Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.
        END
      }

      variable "monitoring_service" {
        type        = string
        default     = "monitoring.googleapis.com/kubernetes"
        description = <<-END
          The monitoring service that the cluster should write metrics to.
          Automatically send metrics from pods in the cluster to the Google
          Cloud Monitoring API. VM metrics will be collected by Google Comput
          Engine regardless of this setting Available options include
          `monitoring.googleapis.com`, and `none`.
        END
      }

      variable "resource_labels" {
        type        = map(string)
        default     = {}
        description = <<-END
          The GCE resource labels (a map of key/value pairs) to be applied to
          the cluster.

          For details please see https://cloud.google.com/kubernetes-engine/docs/how-to/creating-managing-labels
        END
      }

      variable "enable_private_endpoint" {
        type        = bool
        default     = false
        description = <<-END
          Whether the master's internal IP address is used as the cluster endpoint.
        END
      }

      variable "enable_private_nodes" {
        type        = bool
        default     = true
        description = <<-END
          Whether nodes have internal IP addresses only.
        END
      }

      variable "private_ipv6_google_access" {
        type        = string
        description = <<-END
          Configures the IPv6 connectivity to Google Services.
          By default, no private IPv6 access to or from Google Services is
          enabled (all access will be via IPv4).
          Accepted values are `PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED`,
          `INHERIT_FROM_SUBNETWORK`, `OUTBOUND`, and `BIDIRECTIONAL`.
        END
      }

      variable "master_ipv4_cidr_block" {
        type        = string
        description = <<-END
          The IP range in CIDR notation to use for the hosted master network.
        END
      }

      variable "database_encryption_key_name" {
        type        = string
        description = <<-END
          The name of a CloudKMS key to enable application-layer secrets
          encryption settings. If non-null the state will be set to:
          `ENCRYPTED` else `DECRYPTED`.
        END
      }

      variable "release_channel" {
        type        = string
        default     = "STABLE"
        description = <<-END
          The release channel of this cluster. Accepted values are
          `RAPID`, `REGULAR` and `STABLE`.
        END
      }
      variable "node_pool_auto_config" {
        type        = object(node_pool_auto_config)
        default     = null
        description = <<-END
          Node pool configs that apply to auto-provisioned node pools
          in autopilot clusters and node auto-provisioning-enabled clusters.
        END

        readme_example = <<-END
          node_pool_auto_config = {
            network_tags = {
              tags = ["foo", "bar"]
            }
          }
        END

        attribute "network_tags" {
          required    = false
          type        = object(network_tags)
          description = <<-END
            Configures network tags on cluster
          END

          attribute "tags" {
            required    = false
            type        = list(string)
            description = <<-END
              List of tags to apply for all nodes managed by autopilot
            END
          }
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_timeouts" {
        type           = map(timeout)
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.

          Supported resources are: `google_container_cluster`, ...
        END
        readme_example = <<-END
          module_timeouts = {
            google_container_cluster = {
              create = "60m"
              update = "60m"
              delete = "60m"
            }
          }
        END

        attribute "create" {
          type        = string
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "name" {
      type        = string
      description = <<-END
        The name of the cluster.
      END
    }

    output "cluster" {
      type        = object(cluster)
      description = <<-END
        All arguments in `google_container_cluster`.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
          Whether this module is enabled.
        END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture
      END
    }

    section {
      title   = "Terraform GCP Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_cluster_autoscaling
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-gke-autopilot-cluster"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/CONTRIBUTING.md"
  }
}
