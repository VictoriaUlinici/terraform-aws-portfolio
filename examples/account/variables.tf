variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "AWS CLI/SSO profile to use."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key used to encrypt EBS volumes, S3 objects and Secrets Manager secrets in this account."
  type        = string
}

variable "secret_arns" {
  description = "Secrets Manager secret ARNs that instances are allowed to read (e.g. bootstrap credentials)."
  type        = list(string)
  default     = []
}

variable "event_bus_arns" {
  description = "EventBridge event bus ARNs that instances are allowed to publish provisioning events to."
  type        = list(string)
  default     = []
}

variable "instances" {
  description = "One entry per EC2 instance to provision."
  type = map(object({
    ami                = string
    instance_type      = string
    subnet_id          = string
    security_group_ids = list(string)
    os_family          = string # "linux" or "windows"
    key_name           = optional(string)
    root_volume_size   = optional(number, 50)
    additional_disks   = optional(list(number), [])
    user_data          = optional(string)
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "buckets" {
  description = "One entry per S3 bucket to provision."
  type = map(object({
    enable_versioning = optional(bool, false)
    create_iam_user   = optional(bool, false)
    tags              = optional(map(string), {})
  }))
  default = {}
}
