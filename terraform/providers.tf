# This section declares providers for each AWS region

provider "aws" {
  alias  = "primary"
  region = "${var.first-region}"
}

provider "aws" {
  alias  = "secondary"
  region = "${var.second-region}"
}
