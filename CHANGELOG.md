# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Removed minor version constraint from `versions.tf`

### Changed

- Remove redundant service account in unit-complete test

## [0.0.2]

### Added

- Add support for `authenticator_groups_config`

## Changed

- BREAKING: Upgrade provider to `~4.16` to add support for `authenticator_groups_config`

## [0.0.1]

### Added

- Add support for `google_container_cluster` with autopilot enabled

[unreleased]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/releases/tag/v0.0.1
