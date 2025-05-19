output "instance-id" {
  description = "id of instance"
  value       = aws_instance.web.id
}

output "vpc-id" {
  description = "vpc id"
  value       = aws_vpc.my-vpc.id
}