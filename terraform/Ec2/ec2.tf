# EC2 Instances

## fabric :

resource "aws_instance" "fabric" {
  ami = var.fabric-image
  count = var.count_instance
  key_name = var.key_name
  instance_type = var.instance_type
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
  count = var.count_instance
  key_name = var.key_name
  instance_type = var.instance_type
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
  ami = var.Management-image
  count = var.count_instance 
  key_name = var.key_name
  instance_type = var.instance_type
  availability_zone = "us-east-1a"
  user_data = file("management-init.sh")   
  security_groups = [aws_security_group.Management-SG.name]
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
  count = "1"
  key_name = "" 
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