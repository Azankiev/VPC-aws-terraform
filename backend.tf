// informando o local de save do terrafrom

terraform {
  backend "remote" {
    organization = ""

    //"VPC-aws"

    workspaces {
      name = "aws-01"
    }
  }
} 
