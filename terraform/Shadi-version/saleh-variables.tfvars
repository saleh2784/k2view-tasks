variable "aws_region" {
  description = "The AWS region to run on."
  default     = "eu-central-1"
}

variable "uniq" {
  description = "(required param) A uniq variable to diffrincate all terraform provisoned resource from each other!"
}

variable "vpc_cidr" {
  description = "cidr block to be assigned to vpc"
  default     = "10.0.0.0/16"
}

###
###

### EC2  ###

    ### Each EC2 and its atributes ###

variable "ec2_nodes" {
  description = "Each EC2 and its atributes"

  default = {

    fabric = {
      name = "fabric"
      public_subnet = true
    }
    cassandra = {
      name = "cassandra"
      public_subnet = false
    }
    management = {
      name = "management"
      public_subnet = false
    }
    postgres = {
      name = "postgres"
      public_subnet = false
    }
    # studio = {
    #   name = "studio"
    #   public_subnet = false
    # }

  }
  
}

variable "windows_count" {
    description = " AWS Instance count."
    default     = "1"
}
variable "instance_type" {
    description = "Default AWS Instance Type to provision AWS EC2 instances with !."
    default     = "t2.micro"
}
variable "instance_type_windows" {
    description = "Default AWS Instance Typev for windows to provision AWS EC2 instances with !."
    default     = "t2.micro"
}

variable "ami" {
    default = ""
    description = "ami to provision AWS EC2 instances with !. - if left empty will choose latest amzn linux"
}
variable "ami-windows" {
    default = "ami-0dd4486f71af814de"
    description = "Microsoft Windows Server 2016"
}

variable "key_pair_name" {
    description = "Default ssh key to provision AWS EC2 instances with !."
}
variable "key_pair_name_windows" {
    description = "Default ssh key to provision AWS EC2 instances with !."
}

### EC2  ###

###
###

### Subnet Vars ###

variable "subnet_cidr" {
    description = "Cidr to be attached to the to be created subnets"
    default = "10.0.0.0/16"
}

variable "availability_zones" {

  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

### Subnet Vars ###

##
##

### Fabric Specific Vars ###

variable "fabric_app_listening_port" {
    description = "The port that fabric application is listening on"
    default = "3213"
}

variable "fabric_app_listening_protocol" {
    description = "The protocol that fabric application is listening on"
    default = "HTTP"
}

### Fabric Specific Vars ###

###
###

### Default tags ###

variable "owner" {
    description = "Owner Tag to be set !."
    default     = "test_Terraform"
}

variable "project" {
    description = "Project Tag to be set !."
    default     = "test"
}

variable "env" {
    description = "Environment Tag to be set !."
    default     = "test"
}

###
###

### Security Groups ###

    ## Create 5 Empty SGs
    ##   1. Fabirc Group
    ##   2. Cassandra Group
    ##   3. management Group
    ##   4. postgres Group
    ##   5. studio Group

variable "sec_groups" {
  default = {
    fabric = "fabric"
    cassandra = "cassandra"
    management = "management"
    postgres = "postgres"
    studio = "studio"
  }

}

    #### Rules ###

variable "sec_groups_rules" {
  default = [


    # ## Fabric SG Rules ##
      ## InBound ##

    {
      group = "fabric"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 5124,
      protocol = "tcp",
      destination_sg = "studio",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 3213,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 9443,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "ingress"

      port  = 7170,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    
      ## OutBound ##

    {
      group = "fabric"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 5124,
      protocol = "tcp",
      destination_sg = "studio",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 3213,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 9443,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "fabric"
      type = "egress"

      port  = 5432,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
      
    ## Fabric SG Rules ##
    ###
    ###
    ## Cassandra SG Rules ##

      ## InBound ##

    {
      group = "cassandra"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 7000,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 7001,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },  
    {
      group = "cassandra"
      type = "ingress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },  
    {
      group = "cassandra"
      type = "ingress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },    
    {
      group = "cassandra"
      type = "ingress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "ingress"

      port  = 7070,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    

      ## OutBound ##

    {
      group = "cassandra"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 7000,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 7001,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 9042,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 9142,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "cassandra"
      type = "egress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    

    ## Cassandra SG Rules ##
    ###
    ###
    ## postgres SG Rules ##

      ## InBound ##

    {
      group = "postgres"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 5432,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 5432,
      protocol = "tcp",
      destination_sg = "studio",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "ingress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    
      ## OutBound ##

    {
      group = "postgres"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "postgres"
      type = "egress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },

    ## postgres SG Rules ##
    ###
    ###
    ## studio SG Rules ##

      ## InBound ##

    {
      group = "studio"
      type = "ingress"

      port  = 3389,
      protocol = "tcp",
      destination_sg = "",
      cidr_block = "0.0.0.0/0",
    },
    
      ## OutBound ##

    {
      group = "studio"
      type = "egress"

      port  = 3389,
      protocol = "tcp",
      destination_sg = "",
      cidr_block = "0.0.0.0/0",
    },
    
    ### studio SG Rules ###
    ###
    ###
    ## management SG Rules ##

    ## InBound ##

    {
      group = "management"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "management"
      type = "ingress"

      port  = 3100,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },

      ## OutBound ##

    {
      group = "management"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 22,
      protocol = "tcp",
      destination_sg = "management",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 9100,
      protocol = "tcp",
      destination_sg = "postgres",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 7070,
      protocol = "tcp",
      destination_sg = "cassandra",
      cidr_block = "",
    },
    {
      group = "management"
      type = "egress"

      port  = 7170,
      protocol = "tcp",
      destination_sg = "fabric",
      cidr_block = "",
    },

  ]
}

### Security Groups ###

###
###