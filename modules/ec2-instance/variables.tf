variable "hostname" {
  description = "Name tag / hostname assigned to the instance."
  type        = string
}

variable "ami" {
  description = "AMI ID to launch."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "subnet_id" {
  description = "Subnet the instance is launched into."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the instance."
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile to attach."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script content."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key used to encrypt the root and additional EBS volumes."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size (GiB) of the root volume."
  type        = number
  default     = 50
}

variable "additional_disks" {
  description = "Sizes (GiB) of extra EBS volumes to attach, one per entry."
  type        = list(number)
  default     = []
}

variable "os_family" {
  description = "Used to pick the correct device naming scheme for extra disks."
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.os_family)
    error_message = "os_family must be either \"linux\" or \"windows\"."
  }
}

variable "tags" {
  description = "Additional tags merged into the default tag set."
  type        = map(string)
  default     = {}
}
