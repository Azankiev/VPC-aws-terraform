//definindo variaves para facilitar a replicação do codigo  e configuração da infra

variable "vpc_configuration_B" {


  type = object({
    cidr_block = string
    //vpc_id =string

    subnetsB = list(object({
      name_b       = string
      public_b     = bool
      cidr_block_b = string

    }))
  })

  // definindo um valor padrão para o cidr e inserindo informações as subnets
  default = {
    cidr_block = "10.2.0.0/21"
    subnetsB = [
      {
        name_b       = "B-private-a"
        cidr_block_b = "10.2.1.0/24"
        public_b     = false
       
      },
      {
        name_b       = "B-public-a"
        cidr_block_b = "10.2.2.0/24"
        public_b     = true
       
      },
      {
        name_b       = "B-private-b"
        cidr_block_b = "10.2.3.0/24"
        public_b     = false
       
      },
      {
        name_b       = "B-public-b"
        cidr_block_b = "10.2.4.0/24"
        public_b     = true
        
      },

      {
        name_b       = "B-public-c"
        cidr_block_b = "10.2.5.0/24"
        public_b     = true
       
      },

      {
        name_b       = "B-private-c"
        cidr_block_b = "10.2.6.0/24"
        public_b     = false
    
      },
    ]
  }
}
