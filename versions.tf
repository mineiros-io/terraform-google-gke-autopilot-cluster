# ----------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
