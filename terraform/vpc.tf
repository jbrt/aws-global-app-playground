# Describe the networks on each regions

module "vpc-first" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "1.60.0"
  provider         = "aws.primary"
  name             = "vpc-${var.project_name}"
  cidr             = "${var.first_cidr}"
  azs              = "${var.first_azs}"
  public_subnets   = "${var.first_public_subnets}"
  private_subnets  = "${var.first_private_subnets}"
  database_subnets = "${var.first_database_subnets}"

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = "${local.tags}"
}

module "vpc-second" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "1.60.0"
  provider         = "aws.secondary"
  name             = "vpc-${var.project_name}"
  cidr             = "${var.second_cidr}"
  azs              = "${var.second_azs}"
  public_subnets   = "${var.second_public_subnets}"
  private_subnets  = "${var.second_private_subnets}"
  database_subnets = "${var.second_database_subnets}"

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = "${local.tags}"
}
