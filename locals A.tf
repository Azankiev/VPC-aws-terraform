//Arquivo para fazer filtro das subnets e a configuração



locals {
  //Mostar as lista de subnetes privada
  private_subnets = sort([for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == false])
  //Mostar as lista de subnetes publicas
  public_subnets = sort([for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == true])

  // listar as sbunets de forma igual para nao haver mais subnets do que azs
  azs = sort(slice(data.aws_availability_zones.available.zone_ids, 0, length(local.private_subnets)))

  //conectando os pares de cada subnete
  subnet_pairs = zipmap(local.private_subnets, local.public_subnets)


  // conectando os pares em cada azs

  az_pais = merge(
    zipmap(local.private_subnets, local.azs),
    zipmap(local.public_subnets, local.azs)
  )
}


