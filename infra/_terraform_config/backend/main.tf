resource "aws_s3_bucket" "bucket" {
  bucket = local.name

  force_destroy = local.force_destroy
  versioning {
    enabled = local.versioning
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}