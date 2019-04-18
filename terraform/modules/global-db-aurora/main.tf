# Creation a Global DB

# Create a password for the Global DB

resource "random_string" "password" {
  length  = 16
  special = false
}

# Create a Global Cluster

resource "aws_rds_global_cluster" "global_db" {
  provider                  = "aws.primary"
  global_cluster_identifier = "${var.db_name}"
}

# Create the DB instance on the first region

resource "aws_db_subnet_group" "primary_subnet_group" {
  provider    = "aws.primary"
  name        = "${var.db_name}_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["${var.first_db_subnets}"]
  tags        = "${var.tags}"
}

resource "aws_rds_cluster" "primary" {
  provider                  = "aws.primary"
  availability_zones        = "${var.first_azs}"
  database_name             = "${var.db_name}"
  master_username           = "${var.db_username}"
  master_password           = "${random_string.password.result}"
  engine_mode               = "global"
  global_cluster_identifier = "${aws_rds_global_cluster.global_db.id}"
  db_subnet_group_name      = "${aws_db_subnet_group.primary_subnet_group.name}"
  skip_final_snapshot       = true
  tags                      = "${var.tags}"
}

resource "aws_rds_cluster_instance" "primary" {
  provider             = "aws.primary"
  instance_class       = "${var.db_instance}"
  db_subnet_group_name = "${aws_db_subnet_group.primary_subnet_group.name}"
  cluster_identifier   = "${aws_rds_cluster.primary.id}"
  tags                 = "${var.tags}"
}

# Create the DB instance on the second region

resource "aws_db_subnet_group" "secondary_subnet_group" {
  provider    = "aws.secondary"
  name        = "${var.db_name}_subnet_group"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["${var.second_db_subnets}"]
  tags        = "${var.tags}"
}

resource "aws_rds_cluster" "secondary" {
  depends_on                = ["aws_rds_cluster_instance.primary", "aws_rds_global_cluster.global_db"]
  provider                  = "aws.secondary"
  availability_zones        = "${var.second_azs}"
  engine_mode               = "global"
  global_cluster_identifier = "${aws_rds_global_cluster.global_db.id}"
  db_subnet_group_name      = "${aws_db_subnet_group.secondary_subnet_group.name}"
  skip_final_snapshot       = true
  tags                      = "${var.tags}"
}

resource "aws_rds_cluster_instance" "secondary" {
  provider             = "aws.secondary"
  depends_on           = ["aws_rds_cluster_instance.primary", "aws_rds_global_cluster.global_db"]
  instance_class       = "${var.db_instance}"
  db_subnet_group_name = "${aws_db_subnet_group.secondary_subnet_group.name}"
  cluster_identifier   = "${aws_rds_cluster.secondary.id}"
  tags                 = "${var.tags}"
}
