# ==============================================================================
# SECURITY GROUPS
# ==============================================================================

# Public Security Group (Web Tier: Allows HTTP & SSH from anywhere)
resource "aws_security_group" "public_sg" {
  name        = "${var.project_name}-public-sg"
  description = "Allow inbound HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-public-sg" }
}

# Private Security Group (App Tier: Allows SSH and HTTP ONLY from Public SG)
resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-private-sg"
  description = "Allow inbound traffic from public subnet only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow SSH from Public Instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id] # Restricted to public SG
  }

  ingress {
    description     = "Allow App/Web traffic from Public Subnet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Outbound traffic routes via NAT Gateway
  }

  tags = { Name = "${var.project_name}-private-sg" }
}

# ==============================================================================
# EC2 INSTANCES
# ==============================================================================

# 1. EC2 Instance in PUBLIC Subnet 1
resource "aws_instance" "public_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id # Assigns to first public subnet
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.project_name}-public-web"
  }
}

# 2. EC2 Instance in PRIVATE Subnet 1
resource "aws_instance" "private_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[0].id # Assigns to first private subnet
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false # Strict isolation
  key_name                    = var.key_name

  tags = {
    Name = "${var.project_name}-private-app"
  }

  # Ensure the NAT Gateway route exists so the private instance can reach internet repos if needed
  depends_on = [aws_route_table_association.private]
}