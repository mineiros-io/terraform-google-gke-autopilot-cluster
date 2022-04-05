[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-module-template)

[![Build Status](https://github.com/mineiros-io/terraform-module-template/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-module-template/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-module-template.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-module-template/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-module-template

A [Terraform] module for [Amazon Web Services (AWS)][aws].

**_This module supports Terraform version 1
and is compatible with the Terraform AWS Provider version 3._**

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
  - [AWS Documentation IAM](#aws-documentation-iam)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources:

- `null_resource`

and supports additional features of the following modules:

- [mineiros-io/something/google](https://github.com/mineiros-io/terraform-google-something)

## Getting Started

Most common usage of the module:

```hcl
module "terraform-module-template" {
  source = "git@github.com:mineiros-io/terraform-module-template.git?ref=v0.0.1"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`example_required`**](#var-example_required): *(**Required** `string`)*<a name="var-example_required"></a>

  The name of the resource

- [**`example_name`**](#var-example_name): *(Optional `string`)*<a name="var-example_name"></a>

  The name of the resource

  Default is `"optional-resource-name"`.

- [**`example_user_object`**](#var-example_user_object): *(Optional `object(user)`)*<a name="var-example_user_object"></a>

  Default is `{}`.

  Example:

  ```hcl
  user = {
    name        = "marius"
    description = "The guy from Berlin."
  }
  ```

  The `user` object accepts the following attributes:

  - [**`name`**](#attr-example_user_object-name): *(**Required** `string`)*<a name="attr-example_user_object-name"></a>

    The name of the user

  - [**`description`**](#attr-example_user_object-description): *(Optional `string`)*<a name="attr-example_user_object-description"></a>

    A description describng the user in more detail

    Default is `""`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags.
  Tags defined with `module_tags` can be overwritten by resource-specific tags.

  Default is `{}`.

  Example:

  ```hcl
  module_tags = {
    environment = "staging"
    team        = "platform"
  }
  ```

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `null_resource`, ...

  Example:

  ```hcl
  module_timeouts = {
    null_resource = {
      create = "4m"
      update = "4m"
      delete = "4m"
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

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`module_tags`**](#output-module_tags): *(`map(string)`)*<a name="output-module_tags"></a>

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

### AWS Documentation IAM

- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

### Terraform AWS Provider Documentation

- https://www.terraform.io/docs/providers/aws/r/iam_role.html
- https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
- https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
- https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

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

[homepage]: https://mineiros.io/?ref=terraform-module-template
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-module-template/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-module-template/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-module-template/issues
[license]: https://github.com/mineiros-io/terraform-module-template/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-module-template/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-module-template/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-module-template/blob/main/CONTRIBUTING.md
