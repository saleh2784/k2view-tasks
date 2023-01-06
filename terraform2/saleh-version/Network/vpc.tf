# create vpc

resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "lab-vpc"
  }
}
































/* 

# 2. create internet gateway

resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id
  
}

# 3. create route table

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

# 4. create subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "lab-subnet-1"
  }
}

# 5. create route table association

resource "aws_route_table_association" "lab-association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.lab-route-table.id
}


# 6. Create a network interface with an ip in the subnet that was created in step 4 

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50","10.0.1.51"]
  security_groups = [aws_security_group.TF-SG.id]

}

# 8. Assign an elastic IP to the network interface created in step 6

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = ["10.0.1.50","10.0.1.51"]
  depends_on = [aws_internet_gateway.lab-gw]
    
}

 */
