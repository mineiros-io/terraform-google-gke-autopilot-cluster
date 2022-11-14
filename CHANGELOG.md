# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0]

### Added

- Add support for `monitoring_config` block
- Add support for `managed_prometheus` block inside `monitoring_config`

### Removed

- BREAKING CHANGE: Remove variable `monitoring_enable_components`
- BREAKING CHANGE: Remove `var.module_enabled` output

  ###### old format

  ```
  monitoring_enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  ```

  ###### new format
  ```
  monitoring_config = {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
    managed_prometheus = {
      enabled = false
    }
  }
  ```

## [0.0.4]

### Added

- Add support for `node_pool_auto_config {}` with `network_tags`

### Changed

- BREAKING: Upgraded provider to `~> 4.34` to and switched to `google-beta` Terraform Provider for adding support for `node_pool_auto_config`

## [0.0.3]

### Fixed

- Remove minor version constraint from `versions.tf`

### Changed

- Remove redundant service account in unit-complete test

## [0.0.2]

### Added

- Add support for `authenticator_groups_config`

## Changed

- Upgrade provider to `~> 4.16` to add support for `authenticator_groups_config`

## [0.0.1]

### Added

- Add support for `google_container_cluster` with autopilot enabled

[unreleased]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.4...v0.1.0
[0.0.4]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/releases/tag/v0.0.1
