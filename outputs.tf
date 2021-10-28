output "joplin_s3_bucket" {
  value       = aws_s3_bucket.joplin.bucket
  description = "The S3 bucket's name"
}

output "joplin_aws_key" {
  value       = aws_iam_access_key.joplin.id
  description = "AWS key in Joplin"
}

output "joplin_aws_secret" {
  value       = aws_iam_access_key.joplin.secret
  description = "AWS secret in Joplin"
  sensitive   = true
}