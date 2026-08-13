output "target_group_arns" {
  description = "Map of service name to target group ARN."
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}
