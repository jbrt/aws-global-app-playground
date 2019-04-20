# Creating a DynamoDB Global table

resource "aws_dynamodb_table" "first-region-table" {
  provider         = "aws.primary"
  hash_key         = "${var.hash_key}"
  name             = "${var.global_table}"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = "${var.read_capacity}"
  write_capacity   = "${var.write_capacity}"
  attribute        = "${var.table_schema}"
  tags             = "${var.tags}"
}

resource "aws_dynamodb_table" "second-region-table" {
  provider         = "aws.secondary"
  hash_key         = "${var.hash_key}"
  name             = "${var.global_table}"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = "${var.read_capacity}"
  write_capacity   = "${var.write_capacity}"
  attribute        = "${var.table_schema}"
  tags             = "${var.tags}"
}

resource "aws_dynamodb_global_table" "global-table" {
  depends_on = ["aws_dynamodb_table.first-region-table", "aws_dynamodb_table.second-region-table"]
  provider   = "aws.primary"

  name = "${var.global_table}"

  replica {
    region_name = "${var.first_region}"
  }

  replica {
    region_name = "${var.second_region}"
  }
}
