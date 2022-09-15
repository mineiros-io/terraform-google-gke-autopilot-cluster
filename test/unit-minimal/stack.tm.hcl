stack {
  name        = "Mineiros - Unit Test - Minimal Module Usage"
  description = <<EOD
    This module tests a minimal set of features.
    The purpose of this test is to test all defaults for optional arguments and just provide the required arguments.
  EOD
}

# in this stack we want to test the exact minimum provider version so let's set contraint accodingly
globals {
  provider_version_constraint = global.minimum_provider_version
}
