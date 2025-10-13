terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_s3_bucket" "public_bucket" {
  bucket = var.bucket_name # must be globally unique
  tags = {
    Name = "${var.prefix}-s3-bucket"
  }
}

resource "aws_iam_user" "storage_user" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy" "storage_policy" {
  name = "rails-storage-policy"
  user = aws_iam_user.storage_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ActiveStorageAccess"
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.public_bucket.arn}/*"
      },
      {
        Sid      = "ListBucket"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.public_bucket.arn
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.id
  policy = data.aws_iam_policy_document.public_bucket_policy.json
}

data "aws_iam_policy_document" "public_bucket_policy" {
  version = "2012-10-17"
  statement {
    sid = "AllowPublicRead"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.public_bucket.arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_iam_access_key" "storage_key" {
  user = aws_iam_user.storage_user.name
}