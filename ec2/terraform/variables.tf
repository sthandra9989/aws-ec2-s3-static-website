variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c7217cdde317cfec"  # Amazon Linux 2023 AMI in us-east-1
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
  # Replace with your IP address in format: "YOUR_IP/32"
  default     = "0.0.0.0/0"  # Not recommended for production
} 