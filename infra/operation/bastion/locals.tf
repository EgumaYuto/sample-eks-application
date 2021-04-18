locals {
  role          = "bastion"
  vpc_id        = data.terraform_remote_state.vpc.outputs.id
  subnet_id     = data.terraform_remote_state.private_subnet.outputs.ids[0]
  cidr_block    = var.main_vpc_cidr_block
  ami           = "ami-06098fd00463352b6"
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered
}