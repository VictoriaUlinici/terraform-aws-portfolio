output "target_group_arns" {
  description = "Map of service name to target group ARN."
  value       = module.reverse_proxy.target_group_arns
}

output "shared_subnet_ids" {
  description = "Map of subnet key to subnet ID."
  value       = module.shared_subnets.subnet_ids
}
