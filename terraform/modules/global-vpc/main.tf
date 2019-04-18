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
  tags                 = "${var.tags}"

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
  tags                 = "${var.tags}"

  providers = {
    "aws" = "aws.secondary"
  }
}

# VPC Peering

resource "aws_vpc_peering_connection" "peer" {
  provider    = "aws.primary"
  peer_vpc_id = "${module.second-vpc.vpc_id}"
  vpc_id      = "${module.first-vpc.vpc_id}"
  peer_region = "${var.second_region}"
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.secondary"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

## Creation of the routing between these VPCs

# Declare the data source
data "aws_vpc_peering_connection" "pcx" {
  provider        = "aws.primary"
  depends_on      = ["aws_vpc_peering_connection.peer", "aws_vpc_peering_connection_accepter.peer"]
  vpc_id          = "${module.first-vpc.vpc_id}"
  peer_cidr_block = "${var.second_cidr}"
}

# Create a route table & route VPC A -> VPC B
resource "aws_route_table" "route-table" {
  provider = "aws.primary"
  vpc_id   = "${module.first-vpc.vpc_id}"
}

resource "aws_route" "route" {
  provider                  = "aws.primary"
  route_table_id            = "${aws_route_table.route-table.id}"
  destination_cidr_block    = "${var.second_cidr}"
  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pcx.id}"
}

# Create a route table & route VPC B -> VPC A
resource "aws_route_table" "route-table-second" {
  provider = "aws.secondary"
  vpc_id   = "${module.second-vpc.vpc_id}"
}

resource "aws_route" "route-second" {
  provider                  = "aws.secondary"
  route_table_id            = "${aws_route_table.route-table-second.id}"
  destination_cidr_block    = "${var.first_cidr}"
  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pcx.id}"
}
