output "instance_ids" {
  description = "Map of hostname to instance ID."
  value       = { for k, v in module.instances : k => v.id }
}

output "bucket_ids" {
  description = "Map of bucket key to bucket name."
  value       = { for k, v in module.buckets : k => v.bucket_id }
}
