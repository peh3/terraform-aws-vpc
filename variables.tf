variable "project_name" {
  type        = string
  description = "Prefix for tagging resources"
  default     = "tk-tf"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  type        = string
  description = "Sizing for EC2 instances"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Target SSH key pair"
  default     = "tk-linux-server"
}