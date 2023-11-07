locals {
  //Mostar as lista de subnetes privada
  private_subnets_B = sort([for subnet in var.vpc_configuration_B.subnetsB : subnet.name_b if subnet.public_b == false])
  //Mostar as lista de subnetes publicas
  public_subnets_B = sort([for subnet in var.vpc_configuration_B.subnetsB : subnet.name_b if subnet.public_b == true])

  // listar as sbunets de forma igual para nao haver mais subnets do que azs
  azs_B = sort(slice(data.aws_availability_zones.available.zone_ids, 0, length(local.private_subnets_B)))

  //conectando os pares de cada subnete
  subnet_pairs_B = zipmap(local.private_subnets_B, local.public_subnets_B)


  // conectando os pares em cada azs

  az_pais_B = merge(
    zipmap(local.private_subnets_B, local.azs_B),
    zipmap(local.public_subnets_B, local.azs_B)
  )
}