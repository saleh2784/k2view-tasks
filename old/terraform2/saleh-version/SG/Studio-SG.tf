# Create security group with firewall rules

resource "aws_security_group" "studio-SG" {
  name        = var.security_group
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id


 ingress {
    description = "SSH"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: Any All
  }
  
 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    destination_sg = ["0.0.0./0"] # Any All
    cidr_blocks = ["0.0.0.0/0"] # Source: Any All
  }
  

  tags= {
    Name = var.security_group
  }


}
