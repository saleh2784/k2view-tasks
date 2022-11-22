# create route table

resource "aws_route_table" "lab-route-table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.lab-gw.id
  }

  tags = {
    Name = "lab-route"
  }
}


# create route table association

resource "aws_route_table_association" "lab-association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.lab-route-table.id
}