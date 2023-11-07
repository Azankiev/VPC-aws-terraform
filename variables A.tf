//definindo variaves para facilitar a replicação do codigo  e configuração da infra

variable "vpc_configuration" {


  type = object({
    cidr_block = string
    //vpc_id =string

    subnets = list(object({
      name       = string
      public     = bool
      cidr_block = string

    }))
  })

  // definindo um valor padrão para o cidr e inserindo informações as subnets
  default = {
    cidr_block = "10.0.0.0/21"
    subnets = [
      {
        name       = "private-a"
        cidr_block = "10.0.1.0/24"
        public     = false
        tags={
        
        }
        
      },
      {
        name       = "public-a"
        cidr_block = "10.0.6.0/24"
        public     = true
       
      },
      {
        name       = "private-b"
        cidr_block = "10.0.5.0/24"
        public     = false
      
      },
      {
        name       = "public-b"
        cidr_block = "10.0.0.0/24"
        public     = true
       
      },

      {
        name       = "public-c"
        cidr_block = "10.0.3.0/24"
        public     = true
       
      },

      {
        name       = "private-c"
        cidr_block = "10.0.4.0/24"
        public     = false
        
      },
    ]
  }
}

