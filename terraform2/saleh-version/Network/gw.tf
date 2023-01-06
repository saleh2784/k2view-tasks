# create internet gateway

resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id
  
}
