# Assign an elastic IP to the network interface created in step 6

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = ["10.0.1.50","10.0.1.51"]
  depends_on = [aws_internet_gateway.lab-gw]
    
}


