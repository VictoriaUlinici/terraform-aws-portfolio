variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt objects. If null, SSE-S3 (AES256) is used instead."
  type        = string
  default     = null
}

variable "enable_versioning" {
  description = "Whether to enable object versioning on the bucket."
  type        = bool
  default     = false
}

variable "create_iam_user" {
  description = "Whether to create a dedicated IAM user with programmatic access scoped to this bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the bucket."
  type        = map(string)
  default     = {}
}
