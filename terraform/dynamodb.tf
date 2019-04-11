# Creating a DynamoDB Global table

resource "aws_dynamodb_table" "first-region-table" {
  provider = "aws.primary"
  depends_on = ["module.first-vpc"]

  hash_key         = "myAttribute"
  name             = "myTable"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "myAttribute"
    type = "S"
  }
  tags = "${local.tags}"
}

resource "aws_dynamodb_table" "second-region-table" {
  provider = "aws.secondary"
  depends_on = ["module.second-vpc"]

  hash_key         = "myAttribute"
  name             = "myTable"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "myAttribute"
    type = "S"
  }
  tags = "${local.tags}"
}

resource "aws_dynamodb_global_table" "myTable" {
  depends_on = ["aws_dynamodb_table.first-region-table", "aws_dynamodb_table.second-region-table"]
  provider   = "aws.primary"

  name = "myTable"

  replica {
    region_name = "${var.first-region}"
  }

  replica {
    region_name = "${var.second-region}"
  }
}