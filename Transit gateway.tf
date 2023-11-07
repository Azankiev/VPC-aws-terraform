// permitindo a conexao com os serviços
resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "Tgw-cia"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-one_tgw_attachment" {

  subnet_ids         = ["subnet-0f4b61c82d7ef6b94", "subnet-025f307a136a3105b", "subnet-01d603be64215c201", ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.job_rotation.id
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-two_tgw_attachment" {

  subnet_ids         = ["subnet-0ba5a8b43d8d03fa5", "subnet-02ff6fef4a747b8bd", "subnet-0d51b96dfd19bc997"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.job_rotation_B.id
}