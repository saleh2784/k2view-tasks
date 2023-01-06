### Retrives Latest amazon 2 linux ami ###

data "aws_ami" "latest_amz_linux" {
	most_recent = true
	owners	= ["amazon"]
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-gp2"]
	}

	filter {
		name = "root-device-type"
		values = ["ebs"]
	}

	filter {
		name = "virtualization-type"
		values = ["hvm"]
	}

	filter {
		name = "architecture"
		values = ["x86_64"]
	}
}
