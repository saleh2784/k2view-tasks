############################################################################
                                  ## VPC ##
############################################################################

# Create VPC

resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc-name
  }
}

############################################################################
                                  ## Subnet ##
############################################################################
# Create Subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = var.subnet-cidr-block  # "10.0.1.0/24"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  tags = {
    Name = "lab-subnet-1"
  }
}

############################################################################
                                  ## gateway ##
############################################################################

# Create internet gateway

resource "aws_internet_gateway" "lab-gw" {
  vpc_id = aws_vpc.lab-vpc.id
  
}


############################################################################
                            ## route table ##
############################################################################

# Create route table

resource "aws_route_table" "lab-route-table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = aws_vpc.lab-vpc.cidr_block
    gateway_id = aws_internet_gateway.lab-gw.id
  }

  tags = {
    Name = "lab-route"
  }
}

############################################################################
                      ## route table association ##
############################################################################

# create route table association

resource "aws_route_table_association" "lab-association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.lab-route-table.id
}


############################################################################
                          ## elastic IP ##
############################################################################


# Assign an elastic IP to the network interface created in step 6

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = ["10.0.1.50","10.0.1.51"]
  depends_on = [aws_internet_gateway.lab-gw]
    
}


############################################################################
                            ## Security Group ##
############################################################################

# Create security group for cassandra

resource "aws_security_group" "cassandra-SG" {
  name        = var.cass-sg
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id
  ## NTC the vpc_id


 ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source:cassandra-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: postgres-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: managment-SG
  }
  ingress {
    description = ""
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: cassandra-SG 
  }
  ingress {
    description = ""
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: fabric-SG
  }
  ingress {
    description = ""
    from_port   = 9142
    to_port     = 9142
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: Mangement-SG
  }
  ingress {
    description = ""
    from_port   = 7070
    to_port     = 7070
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: Mangement-SG
  }

 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source: fabric-SG , cassandra-SG , postgres-SG, managment-SG sg-00129702e4344bb75	
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }

  egress {
    description = ""
    from_port   = 7000 
    to_port     = 7000 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 7001 
    to_port     = 7001 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9042
    to_port     = 9042 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 9142
    to_port     = 9142 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: Management-SG
  }
  egress {
    description = ""
    from_port   = 7070
    to_port     = 7070 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: Management-SG
  }

  tags= {
    Name = var.cass-sg
  }

}

# Create security group for fabric:

resource "aws_security_group" "fabric-SG" {
  name        = var.fab-sg
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: any
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source:cassandra-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: postgres-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: managment-SG
  }
  ingress {
    description = ""
    from_port   = 5124
    to_port     = 5124
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = ""
    from_port   = 3213
    to_port     = 3213
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: studio-SG
  }
  ingress {
    description = ""
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: fabric-SG
  }
  ingress {
    description = ""
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9142
    to_port     = 9142
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: Mangement-SG
  }
  ingress {
    description = ""
    from_port   = 7170
    to_port     = 7170
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: Mangement-SG
  }

 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }

  egress {
    description = ""
    from_port   = 5124 
    to_port     = 5124 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 3213 
    to_port     = 3213 
    protocol    = "tcp"
    destination_sg = "studio-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: sudio-SG
  }
  egress {
    description = ""
    from_port   = 9443
    to_port     = 9443 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 9042
    to_port     = 9042 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9142
    to_port     = 9142 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 3100
    to_port     = 3100 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: Management-SG
  }
  egress {
    description = ""
    from_port   = 5432
    to_port     = 5432 
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]
  }

  tags= {
    Name = var.fab-sg
  }

}

# Create security group for postgres:

resource "aws_security_group" "postgres-SG" {
  name        = var.post-sg
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: any
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source:cassandra-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: postgres-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: managment-SG
  }
  ingress {
    description = ""
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = ""
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: studio-SG 
  }
  ingress {
    description = ""
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: managment-SG
  }


 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG , cassandra-SG , postgres-SG, managment-SG
  }
  egress {
    description = ""
    from_port   = 3100
    to_port     = 3100 
    protocol    = "tcp"
    destination_sg = "Management-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: managment-SG
  }


  tags= {
    Name = var.post-sg
  }

}

# Create security group for management : 

resource "aws_security_group" "management-SG" {
  name        = var.manage-sg
  description = "Allow inbound & outbound firewall traffic"
  vpc_id = aws_vpc.lab-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # source: any
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source:cassandra-SG 
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: postgres-SG
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: managment-SG
  }
  ingress {
    description = ""
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: fabric-SG 
  }
  ingress {
    description = ""
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # source: cassandra-SG
  }
  ingress {
    description = ""
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block]  # source: postgres-SG
  }
  
 #Egress means traffic that’s leaving from inside the private network out to the public internet.

  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source: fabric-SG 
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG 
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: postgres-SG
  }
  egress {
    description = ""
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    destination_sg = "managment-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source: managment-SG
  }

  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: fabric-SG
  }
  egress {
    description = ""
    from_port   = 9100 
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: cassandra-SG
  }
  egress {
    description = ""
    from_port   = 9100
    to_port     = 9100 
    protocol    = "tcp"
    destination_sg = "postgres-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] # Source:: postgres-SG
  }
  egress {
    description = ""
    from_port   = 7070
    to_port     = 7070 
    protocol    = "tcp"
    destination_sg = "cassandra-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] 
  }
  egress {
    description = ""
    from_port   = 7170
    to_port     = 7170 
    protocol    = "tcp"
    destination_sg = "fabric-SG"
    cidr_blocks = [aws_vpc.lab-vpc.cidr_block] 
  }
  
  tags= {
    Name = var.manage-sg
  }


}


# Create security group for studio :

resource "aws_security_group" "studio-SG" {
  name        = var.studio-sg
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
  egress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    destination_sg = ["0.0.0./0"] # Any All
    cidr_blocks = ["0.0.0.0/0"] # Source: Any All
  }
  

  tags= {
    Name = var.studio-sg
  }
}

############################################################################
                            ## genrate key ##
############################################################################



resource "aws_key_pair" "lab-key" {
  key_name   = "lab-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create local file
resource "local_file" "TF-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
  
}



############################################################################
                            ## EC2 Instances ##
############################################################################

## fabric :

resource "aws_instance" "fabric" {
  ami = var.fabric-image
  count = var.fabric_instance
  key_name = var.key_name
  instance_type = var.fab_instance_type
  availability_zone = "us-east-1a"
  user_data = file("fabric-init.sh")
  security_groups = [aws_security_group.fabric-SG.name]
  iassociate_public_ip_address = true # Auto-assign public IP "enable"

  tags= {
    Name = var.fab_name
    Owner : var.owner
    Project : var.project
    Env : var.env
  }
}

## cassandra :

resource "aws_instance" "cassandra" {
  ami = var.cassandra-image
  count = var.cassandra_instance
  key_name = var.key_name
  instance_type = var.cass_instance_type
  availability_zone = "us-east-1a"
  user_data = file("cassandra-init.sh") 
  security_groups = [aws_security_group.cassandra-SG.name]
  iassociate_public_ip_address = true # Auto-assign public IP "enable"

  tags= {
    Name = var.cas_name
    Owner : var.owner
    Project : var.project
    Env : var.env
  }
}


## Management :

resource "aws_instance" "Management" {
  ami = var.management-image
  count = var.management_instance
  key_name = var.key_name
  instance_type = var.instance_type
  availability_zone = "us-east-1a"
  user_data = file("management-init.sh")   
  security_groups = [aws_security_group.management-SG.name]
  iassociate_public_ip_address = true # Auto-assign public IP "enable"

  tags= {
    Name = var.mange_name
    Owner : var.owner
    Project : var.project
    Env : var.env
  }
}


## Windows-studio :
resource "aws_instance" "studio-windows" {
  ami = var.sudio-image
  count = var.windows_instance
  key_name = "need to chose exsit key " 
  instance_type = var.windows_type 
  availability_zone = ""
  security_groups = [aws_security_group.studio-SG.name]

  tags= {
    Name = var.studio_name
    Owner : var.owner
    Project : var.project
    Env : var.env
  }
}
