module "ec2" {
  source = "./module/ec2"

  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  key_name      = var.key_name
}

module "lambda" {
  source = "./module/lamda"

  ID_vm = module.ec2.ID_vm
}