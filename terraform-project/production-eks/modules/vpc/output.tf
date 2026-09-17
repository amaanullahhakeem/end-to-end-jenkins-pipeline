output "aws_vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "aws_vpc_name" {
  value = aws_vpc.main.tags["Name"]
  description = "The name of the VPC"
}

output "aws_public_subnet_a_id" {
  value = aws_subnet.public_a.id
  description = "The ID of the public subnet A"
}

output "aws_public_subnet_b_id" {
  value = aws_subnet.public_b.id
  description = "The ID of the public subnet B"
}

output "aws_nat_gateway_a_id" {
  value = aws_nat_gateway.nat_a.id
  description = "The ID of the NAT gateway A"
}

output "aws_nat_gateway_b_id" {
  value = aws_nat_gateway.nat_b.id
  description = "The ID of the NAT gateway B"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id   
  description = "The ID of the Internet Gateway"
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}



