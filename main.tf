# 1. Create VPC
# We need to provide variables in vpc module, if user want he can overwrite in main.tf file when running
resource "aws_vpc" "vpc_module" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.common_tags, 
    var.vpc_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}

# 2. Create internet gateway and attach it to VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_module.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = local.name
    }
  )
}

# 3. Get availability Zones
# 4. Create Public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.vpc_module.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  #availability_zone = slice(data.aws_availability_zones.azs.names,0,2)[count.index]
  tags = merge(
    var.common_tags,
    var.public_subnets_tags,
    {
      Name = "${local.name}-public-${local.az_names[count.index]}"
    }
  )
}

# 5. Create Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.vpc_module.id
  cidr_block = var.private_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  #availability_zone = slice(data.aws_availability_zones.azs.names,0,2)[count.index]
  tags = merge(
    var.common_tags,
    var.private_subnets_tags,
    {
      Name = "${local.name}-private-${local.az_names[count.index]}"
    }
  )
}

# 6. Create Database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnets_cidr)
  vpc_id     = aws_vpc.vpc_module.id
  cidr_block = var.database_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  #availability_zone = slice(data.aws_availability_zones.azs.names,0,2)[count.index]
  tags = merge(
    var.common_tags,
    var.database_subnets_tags,
    {
      Name = "${local.name}-database-${local.az_names[count.index]}"
    }
  )
}

# 7. create elastic IP
resource "aws_eip" "eip" {
  domain           = "vpc"
}

# 8. Create Nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id # [0] means 1a zone

  tags = merge(
    var.common_tags,
    var.nat_gw_tags,
    {
      Name = "${local.name}-nat-gw"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] # It will depend on Internet
}

# 9. create public route table and add variable public_route_table_tags in the variables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_module.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
      Name = "${local.name}-public"
    }
  )
}

# 9. create private route table and add variable private_route_table_tags in the variables
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_module.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
      Name = "${local.name}-private"
    }
  )
}

# 9. create database route table and add variable database_route_table_tags in the variables
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc_module.id

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
      Name = "${local.name}-database"
    }
  )
}

# 10. create public route and attach the internet gateway for internet connection
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

# 11. create private route and attach the NAT gateway for internet connection for private subnet resources
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

# 12. create database route and attach the NAT gateway for internet connection for database subnet resources
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

# 13. Associte public route table to public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# 14. Associate private route table to private subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# 15. Associate database route table to database subnets
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}

