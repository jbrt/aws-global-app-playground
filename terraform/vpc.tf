# Describe the networks on each regions

module "first-vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "1.60.0"
  name                 = "vpc-${var.project_name}"
  cidr                 = "${var.first_cidr}"
  azs                  = "${var.first_azs}"
  public_subnets       = "${var.first_public_subnets}"
  private_subnets      = "${var.first_private_subnets}"
  database_subnets     = "${var.first_database_subnets}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags                 = "${local.tags}"

  providers = {
    "aws" = "aws.primary"
  }
}

module "second-vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "1.60.0"
  name                 = "vpc-${var.project_name}"
  cidr                 = "${var.second_cidr}"
  azs                  = "${var.second_azs}"
  public_subnets       = "${var.second_public_subnets}"
  private_subnets      = "${var.second_private_subnets}"
  database_subnets     = "${var.second_database_subnets}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags                 = "${local.tags}"

  providers = {
    "aws" = "aws.secondary"
  }
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  provider = "aws.primary"
  vpc_id      = "${module.first-vpc.vpc_id}"
  peer_vpc_id = "${module.second-vpc.vpc_id}"
  auto_accept = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = "aws.secondary"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = "aws.primary"

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.peer.id}"

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = "aws.secondary"

  vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.peer.id}"

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}