output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs for the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs for the private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ip" {
  description = "The public IP address assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "public_instance_ip" {
  description = "Public IP address of the web instance"
  value       = aws_instance.public_ec2.public_ip
}

output "private_instance_ip" {
  description = "Private IP address of the internal application instance"
  value       = aws_instance.private_ec2.private_ip
}