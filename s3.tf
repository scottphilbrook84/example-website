resource "aws_s3_bucket" "website_s3_bucket" {
  bucket = var.fqdn

  acl = "private"
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
 }
}

data "aws_iam_policy_document" "bucket_policy" {

  statement {
    sid = "AllowCFOriginAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.fqdn}/*",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:UserAgent"

      values = [
        var.refer_secret,
      ]
    }

    principals {
      type = "*"
      identifiers = [
        "*"]
    }
  }
}

resource "aws_s3_bucket" "website_s3_bucket_failover" {
  bucket = var.failover_bucket_name
  provider = aws.failover_region
  acl = "private"
  policy = data.aws_iam_policy_document.bucket_policy_failover.json

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
 }
}

data "aws_iam_policy_document" "bucket_policy_failover" {

  statement {
    sid = "AllowCFOriginAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.failover_bucket_name}/*",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:UserAgent"

      values = [
        var.refer_secret,
      ]
    }

    principals {
      type = "*"
      identifiers = [
        "*"]
    }
  }
}