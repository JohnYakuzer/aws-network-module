# VPC CONFIGURATION
resource "aws_vpc" "main" {
  cidr_block = var.cidr-block
  tags = {
    Name = var.vpc-name
  }
}

# SUBNET CONFIGURATION
resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr-block
  availability_zone = each.value.availability-zone

  tags = {
    Name = each.value.subnet-name
  }
}

# INTERNET GATEWAY CONFIGURATION
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.ig-name
  }
}

# ROUTE TABLE CONFIGURATION 
resource "aws_route_table" "main" {
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${each.value.subnet-name}-rt"
  }
}

# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "main" {
  for_each       = var.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}

# DYNAMIC ROUTES CONFIGURATION
resource "aws_route" "main" {
  for_each = {
    for pair in flatten([
      for sn_key, sn_val in var.subnets : [
        for idx, r in sn_val.routes : {
          key  = "${sn_key}-route-${idx}"
          sn   = sn_key
          dest = r.destination-block
          type = r.target-type
        }
      ]
    ]) : pair.key => pair
  }

  route_table_id         = aws_route_table.main[each.value.sn].id
  destination_cidr_block = each.value.dest
  gateway_id = each.value.type == "igw" ? aws_internet_gateway.main.id : null
}