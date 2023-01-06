# Create a network interface with an ip in the subnet that was created in step 4 

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50","10.0.1.51"]
  security_groups = [aws_security_group.TF-SG.id]

  /* attachment {
    instance     = aws_instance.test.id
    device_index = 1
  } */
}


