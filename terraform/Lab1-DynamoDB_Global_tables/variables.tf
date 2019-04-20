####################
# Region variables 
####################

variable "first_region" {
  description = "Name of the first AWS region"
  default     = "eu-west-1"
}

variable "second_region" {
  description = "Name of the second AWS region"
  default     = "us-east-1"
}

terraform {
  required_version = "<= 0.11.13"
}

#####################
# Tags
#####################

locals {
  tags = {
    Project   = "Global App PlayGround"
    Terraform = true
  }
}
