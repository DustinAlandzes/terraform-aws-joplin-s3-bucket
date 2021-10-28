terraform {
  required_version = "~> 1.0.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "joplin" {
  acl           = "private"
  bucket_prefix = "joplin"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_iam_user" "joplin" {
  name = "joplin-s3-bucket-user"
}

resource "aws_iam_access_key" "joplin" {
  user = aws_iam_user.joplin.name
}

resource "aws_iam_user_policy" "joplin" {
  name = "joplin-s3-bucket-user-policy"
  user = aws_iam_user.joplin.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.joplin.arn,
          "${aws_s3_bucket.joplin.arn}/*",
        ]
      }
    ]
  })
}