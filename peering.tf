


resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.vpc_module.id # Requester VPC ID
  peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id
  auto_accept = var.acceptor_vpc_id == "" ? true : false

  tags = merge(
    var.common_tags,
    var.vpc-peering_tags,
    {
        #Name = "${local.name}-default"
        Name = "roboshop-default"
    }
  )
}

# 2. Add route from default VPC (Acceptor) to Roboshop VPC (Requester)
resource "aws_route" "acceptor_route" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.vpc_cidr # Requester VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# 3. Add public subnet route from Requester VPC to default VPC
resource "aws_route" "public_route_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block # Acceptor VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# 3. Add private subnet route from Requester VPC to default VPC
resource "aws_route" "private_route_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block # Acceptor VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# 3. Add databse subnet route from Requester VPC to default VPC
resource "aws_route" "database_route_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block # Acceptor VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}