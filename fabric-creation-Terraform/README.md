<!-- BEGIN_TF_DOCS -->

The following directory hold nessacry Terrafrom files and its child modules

End Result = All AWS fabric nessacary Resources (Infra)

Please Maintain Same Programing Fourm ..

## Requirements

Env Variables :
    var.uniq must be also sent in env

Terraform init Ussage:
    terraform init -backend-config="key=${uniq}/terraform.tfstate"

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_http_redirect_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.fabric_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.fabric_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.subnets_pub_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.subnets_pub_route_associtation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.security_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.security_group_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.priv_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.pub_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.latest_amz_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | ami to provision AWS EC2 instances with !. - if left empty will choose latest amzn linux | `string` | `""` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list` | <pre>[<br>  "eu-central-1a",<br>  "eu-central-1b"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run on. | `string` | `"eu-central-1"` | no |
| <a name="input_ec2_names"></a> [ec2\_names](#input\_ec2\_names) | A list of names to attach as ec2 names - this var amounts to the amount of ec2 to be created.. | `list` | <pre>[<br>  "fabric",<br>  "cassandra",<br>  "kafka"<br>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | Environment Tag to be set !. | `string` | `"Dev"` | no |
| <a name="input_fabric_app_listening_port"></a> [fabric\_app\_listening\_port](#input\_fabric\_app\_listening\_port) | The port that fabric application is listening on | `string` | `"80"` | no |
| <a name="input_fabric_app_listening_protocol"></a> [fabric\_app\_listening\_protocol](#input\_fabric\_app\_listening\_protocol) | The protocol that fabric application is listening on | `string` | `"HTTP"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Default AWS Instance Type to provision AWS EC2 instances with !. | `string` | `"m5.2xlarge"` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Default ssh key to provision AWS EC2 instances with !. | `any` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner Tag to be set !. | `string` | `"PreSales_Terraform"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project Tag to be set !. | `string` | `"PreSales"` | no |
| <a name="input_sec_groups"></a> [sec\_groups](#input\_sec\_groups) | n/a | `map` | <pre>{<br>  "alb": "alb",<br>  "cassandra": "cassandra",<br>  "fabric": "fabric",<br>  "kafka": "kafka"<br>}</pre> | no |
| <a name="input_sec_groups_rules"></a> [sec\_groups\_rules](#input\_sec\_groups\_rules) | n/a | `list` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "destination_sg": "",<br>    "group": "alb",<br>    "port": 0,<br>    "protocol": -1,<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "destination_sg": "",<br>    "group": "alb",<br>    "port": 0,<br>    "protocol": -1,<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "fabric",<br>    "port": 6379,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "fabric",<br>    "port": 3213,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "alb",<br>    "group": "fabric",<br>    "port": 3213,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "alb",<br>    "group": "fabric",<br>    "port": 9443,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "fabric",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "fabric",<br>    "port": 9093,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "fabric",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "fabric",<br>    "port": 6379,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "fabric",<br>    "port": 3213,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "alb",<br>    "group": "fabric",<br>    "port": 3213,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "alb",<br>    "group": "fabric",<br>    "port": 9443,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "fabric",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "fabric",<br>    "port": 9093,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "fabric",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 7000,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 7001,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 9160,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "cassandra",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 7000,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 7001,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 9160,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "cassandra",<br>    "group": "cassandra",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "cassandra",<br>    "port": 9042,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 2888,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 3888,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 9081,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "kafka",<br>    "port": 9093,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "kafka",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 2888,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 3888,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "kafka",<br>    "group": "kafka",<br>    "port": 9081,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "kafka",<br>    "port": 9093,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_block": "",<br>    "destination_sg": "fabric",<br>    "group": "kafka",<br>    "port": 2181,<br>    "protocol": "tcp",<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | Cidr to be attached to the to be created subnets | `string` | `"10.0.0.0/16"` | no |
| <a name="input_uniq"></a> [uniq](#input\_uniq) | (required param) A uniq variable to diffrincate all terraform provisoned resource from each other! | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr block to be assigned to vpc | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->