[<img src="https://raw.githubusercontent.com/mineiros-io/brand/f2042a229e8feb4b188bea0aec4f6f2ad900c82e/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Join Slack][badge-slack]][slack]

# Tests

This directory contains a number of automated tests that cover the functionality of the modules that ship with this repository:

- [unit-disabled] Verifies that no resources are created when the module is disabled by setting `module_enables = false`.

- [unit-minimal] Tests all defaults for required arguments and keeps all optional arguments as defaults.

- [unit-complete] Tests all features of the module while trying to keep execution time and costs minimal.

## Introduction

We are using [Terratest] for automated tests that are located in the
[`test/` directory][testdirectory].

Terratest deploys _real_ infrastructure
(e.g., servers) in a _real_ environment (e.g., AWS account, GCP project, etc.).

The basic usage pattern for writing automated tests with Terratest is to:

1. Write tests using Go's built-in [package testing]: you create a file ending in `_test.go` and run tests with the `go test` command.

2. Use Terratest to execute your _real_ IaC tools (e.g., Terraform, Packer, etc.) to deploy _real_ infrastructure (e.g., servers) in a _real_ environment (e.g., AWS, GCP).

3. Validate that the infrastructure works correctly in that environment by making HTTP requests, API calls, SSH connections, etc.

4. Undeploy everything at the end of the test.

**Note #1**: Some tests create real resources in a cloud environment.
This means they cost money to run, especially if you don't clean up after themselves.
Please be considerate of the resources you create and take extra care to clean everything up when you're done!

**Note #2**: Never hit `CTRL + C` or cancel a build once tests are running, or the cleanup tasks won't run!

**Note #3**: We set `-timeout 45m` on all tests not because they necessarily take 45 minutes,
but because Go has a default test timeout of 10 minutes, after which it does a `SIGQUIT`,
preventing the tests from properly cleaning up after themselves.
Therefore, we set a timeout of 45 minutes to make sure all tests have enough time to finish and cleanup.

## Using Terramate to keep test code clean

We are using [Terramate](https://github.com/mineiros-io/terramate) to keep the test configuration DRY.

All tests will have a generated provider configuration so we do not need to maintain it for each and every test.

Only the `main.tf` and the `.go` code of each test needs to be maintained. So your focus can be writing the tests and you do not need to care about the surrounding configuration.

To set the minimum version of the provider used for tests adjuts the Terramate global variable `minimum_provider_version` and regenerate the code.

This variable should always match the minimal version as set in `versions.tf`.

Install Terramate and run `make terramate` to re-generate the code within the tests.

## How to run the tests

This repository comes with a [Makefile], that helps you to run the tests in a convenient way.

Alternatively, you can also run the tests without Docker.

### Run the tests with Docker

1. Install [Docker]

2. Configure the used provider through environment variables, e.g.:

   - For AWS modules set the credentials in
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
   - For GCP modules set the credentials and configuration in
     - `GOOGLE_CREDENTIALS`
     - `TEST_GCP_PROJECT` - The GCP project to use
     - `TEST_GCP_ORG_DOMAIN` - The organization domain to use
     - `TEST_GCP_BILLING_ACCOUNT` - The billing account to use in tests that require a billing account
   - For GitHub modules set the access token and organization in
     - `GITHUB_TOKEN`
     - `GITHUB_OWNER`

3. Run `make test/docker/unit-tests`

### Run the tests without Docker

1. Install the latest version of [Go].

2. Install [Terraform].

3. Configure the credentials for the used provider as described in the previous section.

4. Install go dependencies: `go mod download`

5. Run all tests: `make test/unit-tests`.

6. Run a specific test: `go test -count 1 -v -timeout 45m -parallel 128 test/example_test.go`

<!-- References -->

[makefile]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/Makefile
[testdirectory]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/tree/main/test
[unit-disabled]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/test/unit-disabled/main.tf
[unit-minimal]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/test/unit-minimal/main.tf
[unit-complete]: https://github.com/mineiros-io/terraform-google-gke-autopilot-cluster/blob/main/test/unit-complete/main.tf
[homepage]: https://mineiros.io/?ref=terraform-google-gke-autopilot-cluster
[terratest]: https://github.com/gruntwork-io/terratest
[package testing]: https://golang.org/pkg/testing/
[docker]: https://docs.docker.com/get-started/
[go]: https://golang.org/
[terraform]: https://www.terraform.io/downloads.html
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f43f5e.svg?logo=slack
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
