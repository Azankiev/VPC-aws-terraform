
// EC2 Security group para criar acesso ssh

resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.job_rotation_B.id
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//permitindo conexão via rds para porta 3306

resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.job_rotation.id
  ingress {
    description = "Allow EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_configuration_B.cidr_block]
  }
}