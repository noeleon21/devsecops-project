variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ec2-instance-web"
}

variable "instance_type" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "t2.micro"
}


variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the vpc"
}

variable "ami_id" {
  description = "This is the value of the ami id"
  type = string
  default = "ami-0953476d60561c955"
  
}

# variable "s3_name" {
#   description = "The name of the S3 bucket"
#   type        = string
#   default     = "my-website-bucket-noelgens-123456"
# }

# variable "s3_website" {
#   description = "The object key (file name in S3)"
#   type        = string
#   default     = "index.html"
# }

# variable "s3_source" {
#   description = "Local file path to upload"
#   type        = string
#   default     = "../app/index.html" # or whatever path you want
# }
