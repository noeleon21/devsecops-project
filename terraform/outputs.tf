output "s3-bucket-name" {
  description = "name of the bucket"
  value       = aws_s3_bucket.bucket_name
}

output "s3-key-name" {
  description = "name of the key"
  value       = aws_s3_object.object_name
}