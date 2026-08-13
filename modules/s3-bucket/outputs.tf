output "bucket_arn" {
  description = "ARN of the bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "Name/ID of the bucket."
  value       = aws_s3_bucket.this.id
}

output "access_policy_arn" {
  description = "ARN of the IAM policy granting read/write access to the bucket."
  value       = aws_iam_policy.access.arn
}

output "access_key_id" {
  description = "Access key ID of the dedicated IAM user (if created)."
  value       = var.create_iam_user ? aws_iam_access_key.this[0].id : null
}

output "secret_access_key" {
  description = "Secret access key of the dedicated IAM user (if created)."
  value       = var.create_iam_user ? aws_iam_access_key.this[0].secret : null
  sensitive   = true
}
