# genrate key ##

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





