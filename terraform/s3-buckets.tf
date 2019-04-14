# Creation of replicated S3 Buckets 

###################
# IAM Role & Policy
###################

# Note: since IAM is a global service we can use the first provider for 
# creating all IAM objects

# Role for replication SRC->TGT
resource "aws_iam_role" "replication-src" {
  provider = "aws.primary"
  name     = "tf-s3-role-replication-src"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# Role for replication TGT->SRC
resource "aws_iam_role" "replication-tgt" {
  provider = "aws.primary"
  name     = "tf-s3-role-replication-tgt"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# IAM Policy for replication SRC->TGT
resource "aws_iam_policy" "replication-src-to-tgt" {
  provider = "aws.primary"
  name     = "tf-s3-role-policy-replication-src"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY
}

# IAM Policy for replication TGT->SRC
resource "aws_iam_policy" "replication-tgt-to-src" {
  provider = "aws.primary"
  name     = "tf-s3-role-policy-replication-tgt"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.destination.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.destination.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
POLICY
}

# Association Role+Policy for SRC->TGT
resource "aws_iam_policy_attachment" "replication-src" {
  provider   = "aws.primary"
  name       = "tf-iam-role-attachment-replication-src"
  roles      = ["${aws_iam_role.replication-src.name}"]
  policy_arn = "${aws_iam_policy.replication-src-to-tgt.arn}"
}

# Association Role+Policy for TGT->SRC
resource "aws_iam_policy_attachment" "replication-tgt" {
  provider   = "aws.primary"
  name       = "tf-iam-role-attachment-replication-tgt"
  roles      = ["${aws_iam_role.replication-tgt.name}"]
  policy_arn = "${aws_iam_policy.replication-tgt-to-src.arn}"
}


#########################
# S3 Buckets
#########################

# S3 Bucket of the second region
resource "aws_s3_bucket" "destination" {
  provider = "aws.secondary"
  bucket   = "${var.s3_second_bucket}"
  region   = "${var.second-region}"
  tags     = "${local.tags}"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication-tgt.arn}"

    rules {
      status = "Enabled"

      destination {
        # We use here the ARN of the Bucket to avoid cycle dependency
        bucket        = "arn:aws:s3:::${var.s3_first_bucket}"
        storage_class = "STANDARD"
      }
    }
  }
}

# S3 Bucket of the first region
resource "aws_s3_bucket" "bucket" {
  provider = "aws.primary"
  bucket   = "${var.s3_first_bucket}"
  acl      = "private"
  region   = "${var.first-region}"
  tags     = "${local.tags}"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication-src.arn}"

    rules {
      status = "Enabled"

      destination {
        # We use here the ARN of the Bucket to avoid cycle dependency
        bucket        = "arn:aws:s3:::${var.s3_second_bucket}"
        storage_class = "STANDARD"
      }
    }
  }
}
