output "id" {
  description = "Instance ID."
  value       = aws_instance.this.id
}

output "arn" {
  description = "Instance ARN."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IP address assigned to the instance."
  value       = aws_instance.this.private_ip
}
