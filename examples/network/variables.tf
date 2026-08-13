variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "AWS CLI/SSO profile to use."
  type        = string
}

variable "vpc_id" {
  description = "VPC hosting the ALB and shared subnets."
  type        = string
}

variable "listener_arns" {
  description = "Map of listener port to listener ARN, for the shared ALB."
  type        = map(string)
}

variable "internal_security_group_id" {
  description = "Security group shared alongside each subnet."
  type        = string
  default     = null
}

variable "services" {
  description = "One entry per routed service, forwarded via the ALB."
  type = map(object({
    listener_port         = number
    host_header           = string
    path_pattern          = optional(string)
    priority              = number
    certificate_arn       = optional(string)
    target_group_port     = number
    target_group_protocol = string
    health_check_path     = string
    target_ips            = list(string)
  }))
  default = {}
}

variable "shared_subnets" {
  description = "One entry per subnet to create and share cross-account via RAM."
  type = map(object({
    cidr_block            = string
    availability_zone     = string
    principal_account_ids = list(string)
  }))
  default = {}
}
