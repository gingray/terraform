# ------------------------------
# Outputs
# ------------------------------
output "AWS_ACCESS_KEY_ID" {
  value     = aws_iam_access_key.storage_key.id
  sensitive = true
}

output "AWS_SECRET_ACCESS_KEY" {
  value     = aws_iam_access_key.storage_key.secret
  sensitive = true
}

output "S3_BUCKET_NAME" {
  value = aws_s3_bucket.public_bucket.bucket
}
