resource "aws_vpc" "job_rotation_B" {
  cidr_block = var.vpc_configuration_B.cidr_block
  //habilitar dns para utilizar o nome de instancias e habilitar o dns suporte
  enable_dns_hostnames = true
  enable_dns_support   = true
   tags ={
          Name = "VPC B"
        }
}


resource "aws_internet_gateway" "gat_cia_B" {
  vpc_id = aws_vpc.job_rotation_B.id

  tags = {
    Name = "GAT B"
  }

}


resource "aws_subnet" "sub_cia_B" {
  // manipulação de lista, criando o mapa 
  for_each = { for subnet in var.vpc_configuration_B.subnetsB : subnet.name_b => subnet }

  //selecionando a az em que a subnets esta sendo utilizada, baseada no nome
  availability_zone_id = local.az_pais_B[each.key]
  // definindo em qual VPC as subnets serão criadas
  vpc_id = aws_vpc.job_rotation_B.id
  //Definido os Cidr blocks para cada subnet
  cidr_block = each.value.cidr_block_b

  //função que permite quais subntes irão ter um ip public
  map_public_ip_on_launch = each.value.public_b
  // inserindo o nome da vpc
  tags = {
    Name = each.key
  }

}

//Criando o nat_gateway

resource "aws_nat_gateway" "Nat_jobrotation_B" {

  for_each = toset(local.private_subnets_B)

  allocation_id = aws_eip.Elastic_ip_B[each.value].id
  subnet_id     = aws_subnet.sub_cia_B[local.subnet_pairs_B[each.value]].id

   tags ={
          Name = "NAT B"
        }

}

// criando ips elastico para a associar as subnets privadas , trabalha como um ip fixo, para que nao mude

resource "aws_eip" "Elastic_ip_B" {
  for_each = toset(local.private_subnets_B)
  vpc      = true

  // informando que o metodo precisa do internet gateway
  depends_on = [
    aws_internet_gateway.gat_cia_B
  ]
}


//routes

resource "aws_route_table" "public_B" {
  vpc_id = aws_vpc.job_rotation_B.id
   tags ={
          Name = "Route B"
        }

}

// criando a rota para o internet gateway

resource "aws_route" "internet_gateway_B" {

  // codigo que define a rota com qualquer endereço para acesso a internet
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.public_B.id
  gateway_id     = aws_internet_gateway.gat_cia_B.id


}

// colocando a route table para ser associado a internet gateway

// publica
resource "aws_route_table_association" "public_association_B" {
  for_each       = toset(local.public_subnets_B)
  subnet_id      = aws_subnet.sub_cia_B[each.value].id
  route_table_id = aws_route_table.public_B.id

}


//privada

resource "aws_route_table" "private_route_B" {
  for_each = toset(local.private_subnets_B)
  vpc_id   = aws_vpc.job_rotation_B.id
}

// criando a rota para o nat gateway
resource "aws_route" "nat_gateway_private_B" {
  for_each               = toset(local.private_subnets_B)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_B[each.value].id
  nat_gateway_id         = aws_nat_gateway.Nat_jobrotation_B[each.value].id

}

// Acesso ao route table
resource "aws_route" "rds_transitgateway" {
  for_each               = toset(local.private_subnets_B)
  destination_cidr_block = "10.0.0.0/21"
  route_table_id         = aws_route_table.private_route_B[each.value].id
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

}

resource "aws_route_table_association" "private_association_B" {
  for_each  = toset(local.private_subnets_B)
  subnet_id = aws_subnet.sub_cia_B[each.value].id

  route_table_id = aws_route_table.private_route_B[each.value].id

}

