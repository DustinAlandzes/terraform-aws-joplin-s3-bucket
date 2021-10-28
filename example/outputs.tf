output "joplin_s3_bucket" {
  value       = module.joplin-s3-bucket.joplin_s3_bucket
  description = "The S3 bucket's name"
}

output "joplin_aws_key" {
  value       = module.joplin-s3-bucket.joplin_aws_key
  description = "AWS key in Joplin"
}

output "joplin_aws_secret" {
  value       = module.joplin-s3-bucket.joplin_aws_secret
  description = "AWS secret in Joplin"
  sensitive   = true
}