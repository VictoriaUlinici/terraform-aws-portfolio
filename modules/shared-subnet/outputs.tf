output "subnet_ids" {
  description = "Map of subnet key to subnet ID."
  value       = { for k, v in aws_subnet.this : k => v.id }
}

output "resource_share_arns" {
  description = "Map of subnet key to RAM resource share ARN."
  value       = { for k, v in aws_ram_resource_share.this : k => v.arn }
}
