resource "aws_s3_bucket" "adrift-example-bucket" {
  bucket = "adrift-example-bucket"
  acl = "private"
  versioning {
    enabled = false
  }

  tags {
    Name = "doomwad-repo"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

    lifecycle_rule {
    id      = "adrift-id-23456"
    enabled = true

    prefix = "optional/"

    tags = {
      "rule"      = "adrift-s3-rule"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

}

resource "aws_s3_bucket_public_access_block" "adrift-example-bucket" {
  bucket                  = aws_s3_bucket.adrift-example-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

