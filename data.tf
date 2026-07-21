# Fetch all active Availability Zones in the current region
data "aws_availability_zones" "aws_az" {
  state = "available"
}

# Dynamically fetch the latest Amazon Linux 2 x86_64 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}