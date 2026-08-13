variable "vpc_id" {
  description = "VPC of the target group(s)."
  type        = string
}

variable "listener_arns" {
  description = "Map of listener port (as string, e.g. \"443\") to listener ARN, for the ALB the services are published on."
  type        = map(string)
}

variable "services" {
  description = "One entry per routed service."
  type = map(object({
    listener_port         = number # which entry of var.listener_arns to attach the rule to
    host_header           = string # host header matched by the listener rule
    path_pattern          = optional(string)
    priority              = number
    certificate_arn       = optional(string) # additional certificate to attach to the listener, if any
    target_group_port     = number
    target_group_protocol = string
    health_check_path     = string
    target_ips            = list(string) # private IPs registered in the target group
  }))
}
