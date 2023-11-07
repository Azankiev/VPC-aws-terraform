resource "aws_vpc" "job_rotation" {
  cidr_block = var.vpc_configuration.cidr_block
  //habilitar dns para utilizar o nome de instancias e habilitar o dns suporte
  enable_dns_hostnames = true
  enable_dns_support   = true
 tags ={
          Name = "VPC A"
        }
}


resource "aws_internet_gateway" "gat_cia" {
  vpc_id = aws_vpc.job_rotation.id
 tags ={
          Name = "GAT A"
        }
}

resource "aws_subnet" "sub_cia" {
  // manipulação de lista, criando o mapa 
  for_each = { for subnet in var.vpc_configuration.subnets : subnet.name => subnet }

  //selecionando a az em que a subnets esta sendo utilizada, baseada no nome
  availability_zone_id = local.az_pais[each.key]
  // definindo em qual VPC as subnets serão criadas
  vpc_id = aws_vpc.job_rotation.id
  //Definido os Cidr blocks para cada subnet
  cidr_block = each.value.cidr_block

  //função que permite quais subntes irão ter um ip public
  map_public_ip_on_launch = each.value.public
  // inserindo o nome da vpc
  tags = {
    Name = each.key
  }

}

//Criando o nat_gateway

resource "aws_nat_gateway" "Nat_jobrotation" {

  for_each = toset(local.private_subnets)

  allocation_id = aws_eip.Elastic_ip[each.value].id
  subnet_id     = aws_subnet.sub_cia[local.subnet_pairs[each.value]].id
   tags ={
          Name = "NAT A"
        }

}

// criando ips elastico para a associar as subnets privadas , trabalha como um ip fixo, para que nao mude
resource "aws_eip" "Elastic_ip" {
  for_each = toset(local.private_subnets)
  vpc      = true

  // informando que o metodo precisa do internet gateway
  depends_on = [
    aws_internet_gateway.gat_cia
  ]
}


//routes

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.job_rotation.id

   tags ={
          Name = "Route A"
        }

}

// criando a rota para o internet gateway

resource "aws_route" "internet_gateway" {

  // codigo que define a rota com qualquer endereço para acesso a internet
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.public.id
  gateway_id     = aws_internet_gateway.gat_cia.id


}

// colocando a route table para ser associado a internet gateway

// publica
resource "aws_route_table_association" "public_association" {
  for_each       = toset(local.public_subnets)
  subnet_id      = aws_subnet.sub_cia[each.value].id
  route_table_id = aws_route_table.public.id

}


//privada

resource "aws_route_table" "private_route" {
  for_each = toset(local.private_subnets)
  vpc_id   = aws_vpc.job_rotation.id
}

// criando a rota para o nat gateway
resource "aws_route" "nat_gateway_private" {
  for_each               = toset(local.private_subnets)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route[each.value].id
  nat_gateway_id         = aws_nat_gateway.Nat_jobrotation[each.value].id

}

//Criando uma rota via transit gateway para que qualquer instancia ec2 lançada tenha acesso ao rds

resource "aws_route" "ec2_transitgateway" {
  for_each               = toset(local.private_subnets)
  destination_cidr_block = "10.2.0.0/21"
  route_table_id         = aws_route_table.private_route[each.value].id
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

}

resource "aws_route_table_association" "private_association" {
  for_each  = toset(local.private_subnets)
  subnet_id = aws_subnet.sub_cia[each.value].id

  route_table_id = aws_route_table.private_route[each.value].id

}