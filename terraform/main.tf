terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = var.instance_name
  }
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = aws_vpc.my-vpc.cidr_block
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "allowedports" {
  name        = "my-web-security-group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allowedports.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allowedports.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allowedports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# resource "aws_s3_bucket" "bucket_name" {
#   bucket = var.s3_name
# }

# resource "aws_s3_bucket_public_access_block" "public_access" {
#   bucket = aws_s3_bucket.bucket_name.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }


# resource "aws_s3_object" "object_name" {
#   bucket = aws_s3_bucket.bucket_name.id
#   key    = var.s3_website
#   source = var.s3_source
# }

# resource "aws_s3_bucket_website_configuration" "example" {
#   bucket = aws_s3_bucket.bucket_name.id

#   index_document {
#     suffix = aws_s3_object.object_name.id
#   }

#   error_document {
#     key = "error.html"
#   }

# }



# # Set bucket policy to allow public read
# resource "aws_s3_bucket_policy" "public_read_policy" {
#   bucket = aws_s3_bucket.bucket_name.id

# policy = jsonencode({
#   Version = "2012-10-17",
#   Statement = [
#     {
#       Sid       = "PublicReadGetObject",
#       Effect    = "Allow",
#       Principal = "*",
#       Action    = "s3:GetObject",
#       Resource  = "${aws_s3_bucket.bucket_name.arn}/*"
#     },
#     {
#       Sid       = "PublicListBucket",
#       Effect    = "Allow",
#       Principal = "*",
#       Action    = "s3:ListBucket",
#       Resource  = aws_s3_bucket.bucket_name.arn
#     }
#   ]
# })

# }
