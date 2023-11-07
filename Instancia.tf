// Criando uma Ec2 numa instancia privada

resource "aws_instance" "ec2_privada" {
  ami                         = "ami-02d1e544b84bf7502"
  instance_type               = "t2.micro"
  key_name                    = "terraformkey"
  subnet_id                   = "subnet-0ba5a8b43d8d03fa5"
  associate_public_ip_address = true

  tags = {
    Name = "ec2_privada_cia"
  }
}