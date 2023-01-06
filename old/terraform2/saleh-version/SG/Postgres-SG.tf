# Create security group with firewall rules

resource "aws_security_group" "postgres-SG" {
  name        = var.security_group
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id


 ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: fabric-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source:cassandra-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: postgres-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: managment-SG
  }
  ingress {
    description = ""
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: fabric-SG 
  }
  ingress {
    description = ""
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: studio-SG 
  }
  ingress {
    description = ""
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # source: Mangement-SG
  }


 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 3100
    to_port     = 3100 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: Management-SG
  }


  tags= {
    Name = var.security_group
  }


}
