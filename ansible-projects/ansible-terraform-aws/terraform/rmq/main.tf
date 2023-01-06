provider "aws" {
    region = "us-east-1"
    profile = var.profile
}

resource "aws_instance" "rmq" {
    ami = "ami-07ebfd5b3428b6f4d" # choose AMI 
    instance_type = "t2.micro"
    key_name = "rabbitmq" # need to generate Key
    vpc_security_group_ids = ["sg-0e2e056a0c9e6abcc"] # need to cretae SG

    tags = {
        Name = var.name
        group = var.group
    }
}