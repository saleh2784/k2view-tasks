# Create security group with firewall rules

resource "aws_security_group" "cassandra-SG" {
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
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: cassandra-SG 
  }
  ingress {
    description = ""
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # source: fabric-SG
  }
  ingress {
    description = ""
    from_port   = 9142
    to_port     = 9142
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # source: Mangement-SG
  }
  ingress {
    description = ""
    from_port   = 7070
    to_port     = 7070
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
    from_port   = 7000 
    to_port     = 7000 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 7001 
    to_port     = 7001 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9042
    to_port     = 9042 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 9142
    to_port     = 9142 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: Management-SG
  }
  egress {
    description = ""
    from_port   = 7070
    to_port     = 7070 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: Management-SG
  }

  tags= {
    Name = var.security_group
  }


}
