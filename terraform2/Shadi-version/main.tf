######## Usage ########
### var.uniq must be also sent in env...
### when initing : ( terraform init -backend-config="key=${uniq}/terraform.tfstate" -reconfigure )

locals {
  ec2_nodes_list = [for ec2 in var.ec2_nodes : ec2]
  ec2_nodes_names = [for ec2 in var.ec2_nodes : ec2.name]
}

### VPC ###

    # Create VPC

resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.uniq}_vpc"
        Env         = var.env
        Owner       = var.owner
        Project     = var.project
    }
}

    # Attach internet_Gateway

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.uniq}_main"
        Env         = var.env
        Owner       = var.owner
        Project     = var.project
    }
}

### VPC ###

###
###

### Subnets ###
    # Theoretically - (If not changed) - should create:
    # 2 Public Subnet
    # 2 Private Subnet

resource "aws_subnet" "pub_subnets" {
  count             = length(var.availability_zones)
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.subnet_cidr, 8, count.index)
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.uniq}-pub-subnets"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }
}

resource "aws_subnet" "priv_subnets" {
  count             = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.subnet_cidr, 8, count.index+length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.uniq}-priv-subnet"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }
}

### Subnets ###

###
###

### Route Tables ###

    # subnets route table

resource "aws_route_table" "subnets_pub_route" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name        = "${var.uniq}-public-route-table"
      Env         = var.env
      Owner       = var.owner
      Project     = var.project
    }
}

    # Gateway Route-Table creation

resource "aws_route" "public_internet_gateway" {
    
    route_table_id         = aws_route_table.subnets_pub_route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.gw.id
}

    # Associate Route table

  resource "aws_route_table_association" "subnets_pub_route_associtation" {
    count          = length(var.availability_zones)
    
    subnet_id      = element(aws_subnet.pub_subnets.*.id, count.index)
    route_table_id = aws_route_table.subnets_pub_route.id
}

### Route Tables ###

###
###

### Security Groups ###
    # Will create the following - as configured by default in Variables:
    #  1. VPC's default SG
    #  2. Cassandra & Kafka SG
    #  3. Fabric SG
    #  4. ALB SG

resource "aws_security_group" "security_groups" {
    for_each       = var.sec_groups
    name        = "${var.uniq}-${each.key}-sg"
    description = "Default ${each.key} SG"
    vpc_id      = aws_vpc.vpc.id

    depends_on = [
        aws_vpc.vpc
    ]

    tags = {
        Name        = "${var.uniq}_${each.key}_sg"
        Env         = var.env
        Owner       = var.owner
        Project     = var.project
        Group       = "${each.key}"
    }
}

resource "aws_security_group_rule" "security_group_rules" {

    count             = length(var.sec_groups_rules)

    depends_on = [
        aws_security_group.security_groups
    ]

    # SG Contents
    type              = var.sec_groups_rules[count.index].type
    from_port         = var.sec_groups_rules[count.index].port
    to_port           = var.sec_groups_rules[count.index].port
    protocol          = var.sec_groups_rules[count.index].protocol

    # If destination_sg is present don't include cidr_blocks
    cidr_blocks       = var.sec_groups_rules[count.index].destination_sg != "" ? null : [var.sec_groups_rules[count.index].cidr_block]

    # SG to allow access to/from (as a source)
    source_security_group_id = var.sec_groups_rules[count.index].destination_sg != "" ? aws_security_group.security_groups["${var.sec_groups_rules[count.index].destination_sg}"].id : null

    # SG to add rule to
    security_group_id = aws_security_group.security_groups["${var.sec_groups_rules[count.index].group}"].id
}

### Security Groups ###

###
###

### Create AWS EC2 instance ###

resource "aws_instance" "nodes" {
  count = length(local.ec2_nodes_list)
  depends_on = [aws_security_group.security_groups]

  security_groups = [aws_security_group.security_groups[local.ec2_nodes_list[count.index].name].id]
  subnet_id = local.ec2_nodes_list[count.index].public_subnet ? aws_subnet.pub_subnets[0].id : aws_subnet.priv_subnets[0].id

  ami = var.ami != "" ? var.ami : data.aws_ami.latest_amz_linux.id
  key_name = var.key_pair_name
  instance_type = var.instance_type

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags= {
    Name = "${local.ec2_nodes_list[count.index].name}_${var.uniq}_node"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }
}

### Create AWS EC2 instance - windows ###

resource "aws_instance" "windows-nodes" {
  count = var.windows_count ## NTC 
  depends_on = [aws_security_group.security_groups]

  security_groups = [aws_security_group.studio.id] # NTC
  subnet_id = local.ec2_nodes_list[count.index].public_subnet ? aws_subnet.pub_subnets[0].id : aws_subnet.priv_subnets[0].id

  ami = var.ami-windows
  key_name = var.key_pair_name_windows ## need to create 
  instance_type = var.instance_type_windows

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags= {
    Name = "studio_node"
    Env         = var.env
    Owner       = var.owner
    Project     = var.project
  }
}

### Create AWS EC2 instance ###

###
###

### ALB ###

    ## Default Configuration

    ## (-80)HTTP -----Redirect------> HTTPS
    ## (443)HTTPS --By-Instance-Id--> Fabric-Node


    ### Creating ALB resource it self ###

# resource "aws_lb" "alb" {
#   name               = "${var.uniq}-ALB"
#   internal           = false

#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.security_groups["alb"].id]

#   subnets            = [for sub in aws_subnet.pub_subnets: sub.id]

#   # subnets            = [aws_subnet.pub_subnets[0].id, aws_subnet.pub_subnets[1].id]

#   tags = {
#     Env         = var.env
#     Owner       = var.owner
#     Project     = var.project
#   }

# }

    ###  Creating empty fabric-node Target Group ###

      ### ALB related TG ###

# resource "aws_lb_target_group" "fabric_tg" {
#   name     = "${var.uniq}-fabric-target-group"
#   port     = var.fabric_app_listening_port # --  Ask louai what is fabric listening on (80 ?  / 443 ?) https ? http ?
#   protocol = var.fabric_app_listening_protocol  # --  Ask louai what s fabric listening on https ? http ?
#   vpc_id   = aws_vpc.vpc.id
#   depends_on = [
#     aws_lb.alb
#   ]
# }

    ### Attaching Above Fabric-TG to Relavent Instace ###

# resource "aws_lb_target_group_attachment" "fabric_tg_attachment" {
#   target_group_arn = aws_lb_target_group.fabric_tg.arn
#   target_id        = element(aws_instance.nodes.*.id, index(local.ec2_nodes_names, "fabric"))
#   port             = var.fabric_app_listening_port

#   depends_on = [
#     aws_lb_target_group.fabric_tg,
#     aws_lb.alb
#   ]
# }


    ### Creating Listner resource & Attaching Dynamic target groups to above ALB ###

# resource "aws_lb_listener" "alb_https_listner" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   depends_on = [
#     aws_lb_target_group.fabric_tg,
#     aws_lb_target_group_attachment.fabric_tg_attachment,
# #    aws_lb_listener.alb_https_listner,
#     aws_lb.alb
#   ]

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fabric_tg.arn
#   }
# }


# resource "aws_lb_listener" "alb_https_listner" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
# #  ssl_policy        = "ELBSecurityPolicy-2016-08"
# #  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   depends_on = [
#     aws_lb_target_group.fabric_tg,
#     aws_lb_target_group_attachment.fabric_tg_attachment,
#     aws_lb.alb
#   ]

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fabric_tg.arn
#   }
# }

### ALB ###

###
###

### NLB ###










    ### Creating NLB resource it self ###

# resource "aws_lb" "nlb" {
#   name               = "${var.uniq}-NLB"
#   internal           = false
#   load_balancer_type = "network"

#   subnets            = [aws_subnet.pub_subnets[0].id]

#   enable_deletion_protection = true

#   tags = {
#     Env         = var.env
#     Owner       = var.owner
#     Project     = var.project
#   }
# }

    ### Attaching Dynamic target groups to NLB resource ###

    ### NLB related TGs ###

# resource "aws_lb_target_group" "fabric_tg_nlb" {
#   name     = "${var.uniq}-fabric-target-group-nlb"
#   port     = "22"
#   protocol = "TCP"
#   vpc_id   = aws_vpc.vpc.id
#   depends_on = [
#     aws_lb.nlb
#   ]
# }

        ### SSH Target Group (Fabric-Node) ###

# resource "aws_lb_target_group_attachment" "fabric_ssh_tg_attachment" {
#   target_group_arn = aws_lb_target_group.fabric_tg_nlb.arn
#   target_id        = element(aws_instance.nodes.*.id, index(local.ec2_nodes_names, "fabric"))
#   port             = "22"

#   depends_on = [
#     aws_lb_target_group.fabric_tg_nlb,
#     aws_lb.nlb
#   ]
# }

    ### Creating Listner resource & Attaching Dynamic target groups to above ALB ###

# resource "aws_lb_listener" "alb_ssh_listner" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = "22"
#   protocol          = "TCP"
#   # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
#   # alpn_policy       = "HTTP2Preferred"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fabric_tg_nlb.arn
#   }
# }

### NLB ###

###
###