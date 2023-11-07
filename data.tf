// criando  um data source para utilizar as informações de AZS , para que não corra o risco do ID se perder

data "aws_availability_zones" "available" {
  state = "available"
}


