##################
# Region variables 
##################

variable "first_region" {
  description = "Name of the first AWS region"
  default     = "eu-west-1"
}

variable "second_region" {
  description = "Name of the second AWS region"
  default     = "us-east-1"
}

#####################
# Providers variables 
#####################

# AWS Providers

provider "aws" {
  alias  = "primary"
  region = "${var.first_region}"
}

provider "aws" {
  alias  = "secondary"
  region = "${var.second_region}"
}

################
# S3 Buckets
################

variable "s3_first_bucket" {
  description = "Name of the bucket on the first region"
  default     = "global-playground-first-region"
}

variable "s3_second_bucket" {
  description = "Name of the bucket on the second region"
  default     = "global-playground-second-region"
}

#####################
# Tags
#####################

variable "tags" {
  description = "Dictionary of tags"
  type        = "map"
  default     = {}
}
