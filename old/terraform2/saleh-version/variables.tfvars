#################################################################
                        ### Region ###
#################################################################

variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "us-east-2" 
}

#################################################################
                        ### VPC & Subnet ###
#################################################################
variable "vpc-name" { 
    description = " VPC name " 
    default     =  "lab-vpc" 
}

variable "subnet-cidr-block" { 
    description = "subnet-cidr-block" 
    default     = "10.0.1.0/24" 
}

#################################################################
                        ### KEY ###
#################################################################

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "TF_key" 
}

#################################################################
                  ### instance_type ###
#################################################################

variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.micro"
}
variable "windows_type" { 
    description = "windows instance type " 
    default     =  ""
}
#################################################################
                        ### AMI ###
#################################################################

### AMI ###

variable "fabric-image" { 
    description = "fabric-image" 
    default     = "ami-0caef02b518350c8b" 
}
variable "cassandra-image" { 
    description = "cassandra-image" 
    default     = "ami-0caef02b518350c8b" 
}
variable "Management-image" { 
    description = "Management-image" 
    default     = "ami-0caef02b518350c8b" 
}
variable "sudio-image" { 
    description = "sudio-image-windows" 
    default     = "ami-0caef02b518350c8b" 
}

#################################################################
                   ### count instance ###
#################################################################
### count instance ###
variable "fabric_instance" { 
    description = "count_instance" 
    default     = "2" 
}
variable "cassandra_instance" { 
    description = "count_instance" 
    default     = "2" 
}
variable "management_instance" { 
    description = "count_instance" 
    default     = "2" 
}
variable "windows_instance" { 
    description = "count_instance" 
    default     = "1" 
}
#################################################################
                        ### Default tags ###
#################################################################

variable "fab_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "fabric-" 
} 
variable "cas_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "cassandra-" 
} 
variable "mange_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "management-" 
} 
variable "studio_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "studio-" 
} 
variable "owner" {
    description = "Owner Tag to be set !."
    default     = "Saleh_Terraform"
}

variable "project" {
    description = "Project Tag to be set !."
    default     = "TDM"
}

variable "env" {
    description = "Environment Tag to be set !."
    default     = "Testing"
}




