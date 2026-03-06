output "vpc_id" {
  value = aws_vpc.main.id
  description = "Defines the ID of the VPC"
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
  description = "Defines the CIDR block of the VPC"
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.main : k => v.id }
  description = "Maps out all the defined subnet IDs"
}

output "igw_id" {
  value = aws_internet_gateway.main.id
  description = "Defines the ID of the Internet Gateway"
}

output "route_table_ids" {
  value = { for k, v in aws_route_table.main : k => v.id }
  description = "Defines all the IDs of the Route Tables"
}