// informando o local de save do terrafrom

terraform {
  backend "remote" {
    organization = "marcofno"

    //"VPC-aws"

    workspaces {
      name = "aws-01"
    }
  }
} 