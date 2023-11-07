resource "aws_db_instance" "banco" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "MeuBanco"
  username             = "admin"
  password             = "12qwawsx"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id

  tags = {
    Name = "Banco-Cia"
  }
}

// colocando o banco de dados em duas subnets, set  multi AZ.
resource "aws_db_subnet_group" "db_subnet" {
  name       = "dbsubnet"
  subnet_ids = ["subnet-025f307a136a3105b", "subnet-01d603be64215c201"]
}

