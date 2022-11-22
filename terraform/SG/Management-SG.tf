# Create security group with firewall rules

resource "aws_security_group" "management-SG" {
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
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: fabric-SG 
  }
  ingress {
    description = ""
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # source: postgres-SG
  }
  
 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source: fabric-SG 
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: cassandra-SG 
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: postgres-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source: managment-SG
  }

  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 9100 
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = ["0.0.0.0/0"] # Source:: postgres-SG
  }
  egress {
    description = ""
    from_port   = 7070
    to_port     = 7070 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    description = ""
    from_port   = 7170
    to_port     = 7170 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  tags= {
    Name = var.security_group
  }


}
