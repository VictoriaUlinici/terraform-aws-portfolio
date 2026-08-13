variable "role_name" {
  description = "Name of the IAM role / instance profile."
  type        = string
}

variable "secret_arns" {
  description = "Secrets Manager secret ARNs the instance is allowed to read. Leave empty to skip the policy statement."
  type        = list(string)
  default     = []
}

variable "kms_key_arns" {
  description = "KMS key ARNs the instance is allowed to use for encrypt/decrypt. Leave empty to skip the policy statement."
  type        = list(string)
  default     = []
}

variable "event_bus_arns" {
  description = "EventBridge event bus ARNs the instance is allowed to publish to. Leave empty to skip the policy statement."
  type        = list(string)
  default     = []
}

variable "additional_policy_arns" {
  description = "Extra managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}
