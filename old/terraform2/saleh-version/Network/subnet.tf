# create subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = var.subnet-cidr-block  # "10.0.1.0/24"
  availability_zone = ["us-east-1a", "us-east-1b"]
  
  tags = {
    Name = "lab-subnet-1"
  }
}
