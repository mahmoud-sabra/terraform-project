resource "aws_eip" "nat-eip" {
  depends_on = [
    aws_internet_gateway.gw
  ]
  vpc = true
  tags = {
    "name" = "nat-eip"
  }
}
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = {
    Name = "nat-gw"
  }
  depends_on = [aws_internet_gateway.gw]
}