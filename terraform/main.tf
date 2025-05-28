terraform {
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    
  }

  backend "s3" {
    bucket         = "noel-terraform-state-bucket123456"
    key            = "terraform/infra.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.allowedports.id]
  subnet_id = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  user_data = "${file("deploy.sh")}"
  tags = {
    Name = var.instance_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true     
  enable_dns_hostnames = true     
}

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = "10.0.0.0/20"
#   cidr_block        = aws_vpc.my-vpc.cidr_block
#   map_public_ip_on_launch = true
#   availability_zone = "us-east-1a"
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
}

resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
  
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

resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  security_group_id = aws_security_group.allowedports.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allowedports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.allowedports.id]
  db_subnet_group_name =  aws_db_subnet_group.default.name
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group-1"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
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
