output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.prisma_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "https_sg_id" {
  description = "ID of the HTTPS security group"
  value       = aws_security_group.https_sg.id
}
