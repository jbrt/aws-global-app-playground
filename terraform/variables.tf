# Region variables 

variable "first-region" {
  description = "Name of the first AWS region"
  default     = "eu-west-1"
}

variable "second-region" {
  description = "Name of the second AWS region"
  default     = "eu-west-3"
}

variable "project_name" {
  description = "General identifier for created resources"
  default     = "global-playground"
}

variable "first_cidr" {
  description = "CIDR on the first region"
  default     = "10.1.0.0/16"
}

variable "first_azs" {
  description = "List of AZs to use on the first region"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "first_public_subnets" {
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "first_private_subnets" {
  default = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "first_database_subnets" {
  default = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}

variable "second_cidr" {
  description = "CIDR on the second region"
  default     = "10.2.0.0/16"
}

variable "second_azs" {
  description = "List of AZs to use on the second region"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "second_public_subnets" {
  default = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}

variable "second_private_subnets" {
  default = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
}

variable "second_database_subnets" {
  default = ["10.2.7.0/24", "10.2.8.0/24", "10.2.9.0/24"]
}

# Tags

locals {
  tags = {
    Project   = "Global App PlayGround"
    Terraform = true
  }
}
