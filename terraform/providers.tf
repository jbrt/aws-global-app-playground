# This section declares providers for each AWS region

# AWS Providers

provider "aws" {
  alias  = "primary"
  region = "${var.first-region}"
}

provider "aws" {
  alias  = "secondary"
  region = "${var.second-region}"
}

# Limit the version of Terraform to use with that template
# Beware: 0.12 version of Terraform will introduce new features but also 
# breaking changes

terraform {
  required_version = "<= 0.11.13"
}