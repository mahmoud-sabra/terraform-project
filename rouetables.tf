# route table for private subnets
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.myiacvpc.id

  tags = {
    Name = "private-rtb"
  }

}
# route table association for private subnets

resource "aws_route_table_association" "priv-subnets-association" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private-rtb.id
}

# route table for public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.myiacvpc.id


  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

# route table association for public subnets
resource "aws_route_table_association" "pub-subnets-association" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public-rtb.id
}