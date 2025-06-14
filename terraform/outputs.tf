output "instance-id" {
  description = "id of instance"
  value       = aws_instance.web.id
}

output "vpc-id" {
  description = "vpc id"
  value       = aws_vpc.my-vpc.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.default.endpoint
}
