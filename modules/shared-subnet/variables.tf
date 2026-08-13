variable "vpc_id" {
  description = "VPC the subnets are created in."
  type        = string
}

variable "internal_security_group_id" {
  description = "Security group shared alongside each subnet (e.g. a common \"allow-internal\" group), so principal accounts can reference it."
  type        = string
  default     = null
}

variable "subnets" {
  description = "One entry per subnet to create and share via RAM."
  type = map(object({
    cidr_block            = string
    availability_zone     = string
    principal_account_ids = list(string) # AWS accounts the subnet (and security group, if set) is shared with
  }))
}
